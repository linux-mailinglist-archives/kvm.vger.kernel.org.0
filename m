Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B184D94B3
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 07:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345216AbiCOGlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 02:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbiCOGlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 02:41:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B8C13D04;
        Mon, 14 Mar 2022 23:40:05 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F517to018472;
        Tue, 15 Mar 2022 06:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=AzXvJw8bHzilviU0/zaDU8CJxWIqagVr4FdHJeYIq/g=;
 b=ImtlLRF9ao2+gmlQq2un4kMoh4jY3ga2xXRwDoquDujF07EScPTh+VqKSGoT67w+XNm9
 uWDKk6fV6CprUI7mlbI+9/bssTYDU3Iqxoz1Upfm7mjNGDvuF8D0Q+Xvpx/7iir2i/sh
 qPyN1sBT1TOpuU5q6cX/Pg1mD1bUyv8QjWUHUBVkuj5u1OxRHwThZw2sThXuVajlctLR
 pyV6+6ujL8VPPBfNT3jUoCWmXtf/+tq8qXHnZfDo1ceF8dw5D3C3mXxeUTEFcmSUo0dE
 I5JAoj6jZNVukyHWVnJujNO7wwfhr2EwA290KLnFF43v0mX9DRiC+ENfawgWwbxKR/45 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etgx0mw6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 06:40:04 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22F6blga027721;
        Tue, 15 Mar 2022 06:40:04 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etgx0mw6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 06:40:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22F6XDgY000707;
        Tue, 15 Mar 2022 06:40:02 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3erk58wusb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 06:40:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22F6dx0B21627242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 06:39:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1111752453;
        Tue, 15 Mar 2022 06:39:59 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.5.92])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C2BAF52477;
        Tue, 15 Mar 2022 06:39:58 +0000 (GMT)
Message-ID: <a244b0c5193b22da1cf968dc7ad2e6fb64d82e67.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v2 3/6] s390x: smp: Fix checks for SIGP
 STOP STORE STATUS
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 15 Mar 2022 07:39:58 +0100
In-Reply-To: <20220311173822.1234617-4-farman@linux.ibm.com>
References: <20220311173822.1234617-1-farman@linux.ibm.com>
         <20220311173822.1234617-4-farman@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Xm1rQm54ItOAgQTrU5zD3o7IJh734nfS
X-Proofpoint-GUID: dRyP850cBn6elPjtf3qnRNWZJpFZZwgw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_14,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=547
 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-11 at 18:38 +0100, Eric Farman wrote:
> In the routine test_stop_store_status(), the "running" part of
> the test checks a few of the fields in lowcore (to verify the
> "STORE STATUS" part of the SIGP order), and then ensures that
> the CPU has stopped. But this is backwards, according to the
> Principles of Operation:
>   The addressed CPU performs the stop function, fol-
>   lowed by the store-status operation (see “Store Sta-
>   tus” on page 4-82).
> 
> If the CPU were not yet stopped, the contents of the lowcore
> fields would be unpredictable. It works today because the
> library functions wait on the stop function, so the CPU is
> stopped by the time it comes back. Let's first check that the
> CPU is stopped first, just to be clear.
> 
> While here, add the same check to the second part of the test,
> even though the CPU is explicitly stopped prior to the SIGP.
> 
> Fixes: fc67b07a4 ("s390x: smp: Test stop and store status on a
> running and stopped cpu")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
