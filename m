Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2304D01A1
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243341AbiCGOnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243329AbiCGOnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:43:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0278D5B88E;
        Mon,  7 Mar 2022 06:42:48 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227DCUqN001030;
        Mon, 7 Mar 2022 14:42:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=KxRlOd4S9TJiKMSDEIq3H0S9uTnSJZ0AQ6tWk+HRuQg=;
 b=RxgylVfGxAiOK53fZ1Ansm8j0nAWQDP1MUHupVke+HUzmWw42muXF/3z6EYW71zNYrYf
 R4eWGcpQsPQEUgAPGBm7DIZedr84z0imwKbK9CfNTzMcPDixQTYQjOaI7I78mRt0QKx+
 9NYScuoXvBeEK9udtqxP/IWc2G0n/tMdVZk3Af+T/2jh2iaz2JOtUUpTYsK86VN0NslI
 ATZ7ojedOUZ1uRVK1/4B6Z+oVKdfQDRVbXvNMHXVljSC/r0+SwgoUkVI1v2VBaYAR/b5
 e8N1a16rWGKmAOwKnd+5EnSu7HTy/a25sf1QUUgFjE2IwoXBHZiPn5MtUVgWGN6ocp2O FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enjqq9xhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 14:42:48 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227ENaSO002070;
        Mon, 7 Mar 2022 14:42:47 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enjqq9xge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 14:42:47 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227EbbcJ010166;
        Mon, 7 Mar 2022 14:42:45 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3eky4j48qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 14:42:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227EggZf43778444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 14:42:42 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B7874203F;
        Mon,  7 Mar 2022 14:42:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF1AA42042;
        Mon,  7 Mar 2022 14:42:41 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.55.208])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 14:42:41 +0000 (GMT)
Message-ID: <4d7026348507cd51188f0fc6300e7052d99b3747.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 6/6] lib: s390x: smp: Convert
 remaining smp_sigp to _retry
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 07 Mar 2022 15:42:41 +0100
In-Reply-To: <1aa3b683-061d-465a-89fa-2c748719564d@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-7-farman@linux.ibm.com>
         <1aa3b683-061d-465a-89fa-2c748719564d@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 91vCyD6j8ql7IIBG-3JU_uIAZv7wB64D
X-Proofpoint-ORIG-GUID: ATELLaXIOAFLPoNJvQgyiymGPfOPA_-e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_05,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:56 +0100, Janosch Frank wrote:
> On 3/3/22 22:04, Eric Farman wrote:
> > A SIGP SENSE is used to determine if a CPU is stopped or operating,
> > and thus has a vested interest in ensuring it received a CC0 or
> > CC1,
> > instead of a CC2 (BUSY). But, any order could receive a CC2
> > response,
> > and is probably ill-equipped to respond to it.
> 
> sigp sense running status doesn't return a cc2, only sigp sense does
> afaik.
> Looking at the KVM implementation tells me that it's not doing more
> than 
> looking at the R bit in the sblk.

From the POP I read _all_ orders may indeed return CC=2: case 1 under
"Conditions precluding Interpretation of the Order Code".

That being said, there are a few more users of smp_sigp (no retry) in
smp.c (the test, not the lib). 

Does it make sense to fix them aswell?
