Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C794D94CA
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 07:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345273AbiCOGrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 02:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbiCOGrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 02:47:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B5E49933;
        Mon, 14 Mar 2022 23:45:59 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F3fqK6021003;
        Tue, 15 Mar 2022 06:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Uo5+ZLwQAs5Mbr7pPkxu3oGrC7DzVKEM7m+zS5CasHU=;
 b=eLyy88poPYOCQp1QIjoj8HZPzSlR32W7q97v/YntsSCwt3fX+br6MZNarlVWl1t08GWF
 W86qX+TdtJddGfiUxlcwtILfkWZOysybsJvatvaZml4+QOLPMOG5wSX0kZivB+7zCcTP
 JQwiC7006RKQKFploGKxz2xTsKoIeZ4jG69fPLulTDOh7JUwXQXpimjYn4nfnEdaCUIi
 TUe/9vMJvGrXUGaS36aXOAstgW2UW2s0jv3fjV3xyOuNoBPKaRX8CFASDqaQqhw1HCDk
 oxFLuusKAgBwKPzL5NXCKYj6WSyaUNmHQA7nAyZyImrmziC3ffsnWFCEJkiRAmBj4FQ2 Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etk49jx8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 06:45:59 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22F6IsVW031324;
        Tue, 15 Mar 2022 06:45:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etk49jx8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 06:45:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22F6hQuq010258;
        Tue, 15 Mar 2022 06:45:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3erk58wv2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 06:45:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22F6jrUo52232576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 06:45:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1178952052;
        Tue, 15 Mar 2022 06:45:53 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.5.92])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C2EE852050;
        Tue, 15 Mar 2022 06:45:52 +0000 (GMT)
Message-ID: <6af8d831ac4bf9343046621588eca99381b1a054.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v2 4/6] s390x: smp: Create and use a
 non-waiting CPU stop
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 15 Mar 2022 07:45:52 +0100
In-Reply-To: <20220311173822.1234617-5-farman@linux.ibm.com>
References: <20220311173822.1234617-1-farman@linux.ibm.com>
         <20220311173822.1234617-5-farman@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UsXzTdHO5xooTC2Qw2DzgRnp0A7zqxSS
X-Proofpoint-GUID: kaRlSBu-DiC7__u-rqcQgE4mIJ0XDW9d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_14,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0
 mlxlogscore=995 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-11 at 18:38 +0100, Eric Farman wrote:
> When stopping a CPU, kvm-unit-tests serializes/waits for everything
> to finish, in order to get a consistent result whenever those
> functions are used.
> 
> But to test the SIGP STOP itself, these additional measures could
> mask other problems. For example, did the STOP work, or is the CPU
> still operating?
> 
> Let's create a non-waiting SIGP STOP and use it here, to ensure that
> the CPU is correctly stopped. A smp_cpu_stopped() call will still
> be used to see that the SIGP STOP has been processed, and the state
> of the CPU can be used to determine whether the test passes/fails.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
