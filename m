Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B254B53C2
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 15:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355408AbiBNOwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 09:52:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiBNOwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 09:52:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C107B868;
        Mon, 14 Feb 2022 06:52:13 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EEIYo1002620;
        Mon, 14 Feb 2022 14:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wQtcKi+WP9r+eZ2x1hKewIdoq5UyhAvVxxqks/Bmx0o=;
 b=kRR7l589De7MzaG9u88CSk2kskux6ZZQ2MFipCI76t1fv28Uom/kjoB61Ulaz7dKEXKN
 9DRtGunP3Cpvb4NDOWOId7wxDuYX6Ton9Cww9RItO0ou2OZYu7KOURHTxc7honrH//Aw
 KoffHzsIal+isCn1g9AIQDjMF8QJLRK++LSanxjtDoHVmJEtc+YnwAJDAM3GGV2CyQYS
 NGPmwPiqdRiIgTSkX8ExtDVFEh8QM3pkZxypS0c25ApEGSoqgQDbbJ5U1gYNdP9xIbBm
 ebdq6oGG9vGIwFiMxeIwUmhQKMEZ3oZ0tPGRs1xrt3Yl3ilGFM28Az2pOV9vT7QpTtx6 yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7cje13dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 14:52:11 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EEKQBN026636;
        Mon, 14 Feb 2022 14:52:10 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7cje13cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 14:52:10 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EElwTf010676;
        Mon, 14 Feb 2022 14:52:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645jekgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 14:52:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EEq5hF24707374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 14:52:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 474314C046;
        Mon, 14 Feb 2022 14:52:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 703EC4C050;
        Mon, 14 Feb 2022 14:52:04 +0000 (GMT)
Received: from [9.171.14.134] (unknown [9.171.14.134])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 14:52:04 +0000 (GMT)
Message-ID: <78e1c95f-26b3-eeb5-7e7e-7b9e79625eb2@linux.ibm.com>
Date:   Mon, 14 Feb 2022 15:52:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 00/10] KVM: s390: Do storage key checking
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20220211182215.2730017-1-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220211182215.2730017-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wIHoKf7dHMci_eHreKeaREJnL9iRMbx3
X-Proofpoint-ORIG-GUID: yzsGOb6HnjoVfBAzuNgddCZHaZcFrWwa
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_06,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 11.02.22 um 19:22 schrieb Janis Schoetterl-Glausch:
> Check keys when emulating instructions and let user space do key checked
> accesses.
> User space can do so via an extension of the MEMOP IOCTL:
> * allow optional key checking
> * allow MEMOP on vm fd, so key checked accesses on absolute memory
>    become possible
> 
> I haven't finished the memop selftest rewrite, but decided to send out a
> new version anyway, since the functional patches are (hopefully) final
> and the memop selftest patch works. I'll reply to it with the
> rewritten version.
> 
> v3: https://lore.kernel.org/kvm/20220209170422.1910690-1-scgl@linux.ibm.com/
> v2: https://lore.kernel.org/kvm/20220207165930.1608621-1-scgl@linux.ibm.com/
> 
> v3 -> v4
>   * rebase
>   * ignore key in memop if skey flag not specified
>   * fix nits in documentation
>   * pick up tags

I queued patches 1-9 for CI runners (and will also queue for next).
