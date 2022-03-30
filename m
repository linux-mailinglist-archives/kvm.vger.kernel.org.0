Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF374EC4E1
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344823AbiC3MtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345939AbiC3Msb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:48:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D98DE0BD;
        Wed, 30 Mar 2022 05:46:44 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UApUFH011049;
        Wed, 30 Mar 2022 12:46:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5r+YlKJfNJTSpDZey3nIgumC3XBr4U1UQSf1fpGKzbM=;
 b=oV6ExeBzdJA13AMqMGmAftGQW6tSBwaZy8WbcK/pYs5ZZyr5aZosLwh/a4C5cJPozlm7
 YZ4lsDbSWBF2k8J6PuzlCoFTSdXRIM75DBoalpEIpTJU0n00jUOldlJH12MqrexC6CX3
 jXdfyN+0m2KsYKlDNV5zBb5dd/KKG+Nv0td6g77SaUoqrelVpMWBBbeybe3bWajQWn3H
 3Qh5Wxy6tTXTY34UayGWnxGatzL9XhWZpbJUNS7cEBRjlDedTsbPjtGTbsa3nwJqyBvy
 xWlnbKUCFCiM6HuYqL1kc1l0CUR7Gk50tIJ/EGgZaIw/T8DVvkI0fgwXCP5zvAXpk8Ug EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3ydcpyhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:46:43 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UCSlKv017353;
        Wed, 30 Mar 2022 12:46:43 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3ydcpyhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:46:42 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UCMPxc030948;
        Wed, 30 Mar 2022 12:46:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf90k8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:46:41 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCkhsm41091436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:46:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 023B252050;
        Wed, 30 Mar 2022 12:46:38 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.63.69])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A9FBD5204E;
        Wed, 30 Mar 2022 12:46:37 +0000 (GMT)
Message-ID: <2633aab12d0ec64bfc353013a3fd6b428070076d.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] s390x: add test for SIGP STORE_ADTL_STATUS order
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Date:   Wed, 30 Mar 2022 14:46:37 +0200
In-Reply-To: <7cca996a-454d-7287-1d91-c7f5908b0f15@linux.ibm.com>
References: <20220328093048.869830-1-nrb@linux.ibm.com>
         <20220328093048.869830-3-nrb@linux.ibm.com>
         <2fafa98b-e342-047a-3a94-cf4111bc7198@linux.ibm.com>
         <c1b585cbd42cff9920488a74ee5a40ed0d5b13f8.camel@linux.ibm.com>
         <7cca996a-454d-7287-1d91-c7f5908b0f15@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qWJv8pLAiCEhKt2Ap7kj8EavMX8NjuIr
X-Proofpoint-GUID: edD1JFcipYTnmpfevhhqRUQUPpRhgET_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 clxscore=1015 malwarescore=0 mlxscore=0 mlxlogscore=915 suspectscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-29 at 13:39 +0200, Janosch Frank wrote:
> > I think that won't work because that function might clean its float
> > registers in the epilogue and hence destroy the contents. Except if
> > you
> > have an idea on how to avoid that?

I missed that this is a theoretical problem because the function will
be inlined anyway.

> About that:
> 
> Well, who guarantees you that the compiler won't change a fpr (and 
> thereby the overlapped vrs) between the vlms here and your infinite
> loop 
> at the end of the function? :-) gcc uses fprs and acrs in the most 
> interesting places and I've just been hit by that again a few hours
> ago.
> 
> I.e. to be safe we'll need to implement the next few lines in
> assembly 
> as well, no?

I guess so. I will go ahead and reimplement everything in assembly?
