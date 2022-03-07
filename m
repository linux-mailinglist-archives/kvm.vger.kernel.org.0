Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825E54CFF02
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 13:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237571AbiCGMnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiCGMnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:43:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481F37667;
        Mon,  7 Mar 2022 04:42:40 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227ABZgx023291;
        Mon, 7 Mar 2022 12:42:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=X77V9YDX6cOyXu2UrlmH/ILe/OY7VyCZNhAz1BtS3qQ=;
 b=jm7+z+3qb+JxZn+CVbYNuylzb9DTZs1M8vGD0hQ+sbQuMXOsb40vUHphnt5QhO7JcYG5
 xYolJc5RhJzuTCEK2lfNSHFSUh1hhWgYfsTRwqnCliZ2Gn+OkbG7dDZpdUL5Q2639x+n
 s/xL9MU6J6fkRlAtSdl4NO3uiHfaOhP+S7jM+B3mlGmFMuRB9KqQNLzDn/PjCz1FPVZB
 BNrj2aQ3IHsqCbthA8NfzrVvuf0w+zJ+TKndh/RJ9jI/Q1Grcmlqv/Pp7zZEMurEBTJf
 09ec5az5g3Pbtdvb1bUnxW7ew4Sfx2c+eDEWKXG+bnDJVrZBI4lqIhBW+GKPT0tn1pXP NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eng30arks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 12:42:39 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227Cc8Pj012426;
        Mon, 7 Mar 2022 12:42:39 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eng30ark6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 12:42:39 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227CgDsj020121;
        Mon, 7 Mar 2022 12:42:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3emk62jyf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 12:42:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227CgXPr54591978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 12:42:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD8674C046;
        Mon,  7 Mar 2022 12:42:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 812824C044;
        Mon,  7 Mar 2022 12:42:33 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.55.208])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 12:42:33 +0000 (GMT)
Message-ID: <7557cd4f9ad74830f01d3ede26dc8d5e58fddc21.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 2/6] s390x: smp: Test SIGP RESTART
 against stopped CPU
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 07 Mar 2022 13:42:33 +0100
In-Reply-To: <20220303210425.1693486-3-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-3-farman@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z_T_4kQHI4u0KsWTfoa0tabruA3IGNPi
X-Proofpoint-ORIG-GUID: 9rgUMFvMK2ivdnvBZWgIRntncXzLzl7k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_04,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 spamscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 mlxlogscore=924 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-03 at 22:04 +0100, Eric Farman wrote:
> test_restart() makes two smp_cpu_restart() calls against CPU 1.
> It claims to perform both of them against running (operating) CPUs,
> but the first invocation tries to achieve this by calling
> smp_cpu_stop() to CPU 0. This will be rejected by the library.
> 
> Let's fix this by making the first restart operate on a stopped CPU,
> to ensure it gets test coverage instead of relying on other callers.
> 
> Fixes: 166da884d ("s390x: smp: Add restart when running test")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
