Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460834AF286
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 14:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiBINUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 08:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiBINUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 08:20:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAB1C0613C9;
        Wed,  9 Feb 2022 05:20:16 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219D4PNE029187;
        Wed, 9 Feb 2022 13:20:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=XEbb1bX3mU+AH8o7kdPVvJwnnsH95xiPpTlFBQORuek=;
 b=YNcd04NAt/5B9Ja+pP3ufeeVoWMNDYXt5YaMPLj+Cy4qwMp+H6ToxJFtgTILG/Q60Xmg
 NbMvrXfRuq5jNaBAi+wZC2/e98C7XlyKbBprqP8Ab/6TFek+Ohy6ZMJ+AQuHl/H2osiY
 iBPDXaCYctpoYWrQEg03Ln6wO47uqfyg0j6vPbkQaWHPCR2YGfommsZwM6MH51utrXC/
 LHYcQDVAxvYBUFB0N5+3Zn/K1Fn+xLy7yesBzUU9FaJSFlvWAwWxTTSzzCgMPlBROuFE
 PcoQOrHJXWdKry9k//Y4/VaCEsdaa+RR2D04LlGrFabn4QGCk5KtruuWVsnZHlpsn0MG 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e47g5sp71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 13:20:14 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219DK37e031470;
        Wed, 9 Feb 2022 13:20:14 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e47g5sp6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 13:20:13 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219DDQFM029041;
        Wed, 9 Feb 2022 13:20:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3e1gv9nmfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 13:20:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219DK8Zv43516290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 13:20:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3CDF4C059;
        Wed,  9 Feb 2022 13:20:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC8264C04E;
        Wed,  9 Feb 2022 13:20:07 +0000 (GMT)
Received: from [9.171.87.52] (unknown [9.171.87.52])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 13:20:07 +0000 (GMT)
Message-ID: <bd09745b-14e3-741c-f1ab-0663a231d019@linux.ibm.com>
Date:   Wed, 9 Feb 2022 14:20:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 05/11] KVM: s390: Add optional storage key checking to
 MEMOP IOCTL
Content-Language: en-US
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
 <20220207165930.1608621-6-scgl@linux.ibm.com>
 <48d1678f-746c-dab6-5ec3-56397277f752@linux.ibm.com>
 <71f07914-d0b2-e98b-22b2-bc05f04df2da@linux.ibm.com>
 <6ea27647-fbbe-3962-03a0-8ca5340fc7fd@linux.ibm.com>
 <29ac0e5c-f77b-04b2-bbf5-cf5a5ca78921@linux.ibm.com>
 <20220209131654.7txhwrax322rjje2@meerkat.local>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220209131654.7txhwrax322rjje2@meerkat.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RinpmSYlIuHEIWmx84P1_nFfz6MDhHSq
X-Proofpoint-ORIG-GUID: qZPO3tRtLHlSKscWh3py92jkEZ2TIlbO
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_07,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 mlxscore=0 bulkscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 09.02.22 um 14:16 schrieb Konstantin Ryabitsev:
> On Wed, Feb 09, 2022 at 10:34:19AM +0100, Christian Borntraeger wrote:
>> CC Konstantin,
>>
>> I hope you can find the right people. Looks that my (and Janis) emaildid not make it to linux-s390 and kvm at vger lists.
>> Message-ID: <6ea27647-fbbe-3962-03a0-8ca5340fc7fd@linux.ibm.com>
> 
> I see it in the archives, though:
> https://lore.kernel.org/linux-s390/6ea27647-fbbe-3962-03a0-8ca5340fc7fd@linux.ibm.com
> https://lore.kernel.org/kvm/6ea27647-fbbe-3962-03a0-8ca5340fc7fd@linux.ibm.com
> 
> Perhaps it was just delayed?

Yes, now they arrived. I had feared that they have been filtered.
Nevermind.
