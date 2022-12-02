Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA68E6405D5
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 12:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiLBLbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 06:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiLBLan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 06:30:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D42DB0C0
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 03:30:00 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B2AvGkA006128
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 11:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=CU3D6/ereBDEM0dQrodGAlbbG2W7J6eVyXQsjKRV4xw=;
 b=I/sPMCn70mW699xXf0TwEFDOz7R73xgJdk0aqTpiRtyRm+QiUFXJtJnRN8wpTrNAfxXp
 dFXJsMR+pBj9N42SSlnhcBttC9I3giXo1u1wlzRZaq318AybyyU8dsYZ/7N8G3MsVzoj
 +BppNf0p419TzIAkKo6bQcj9h4tgATECf+ZQh5JL15BZTG36GjY4v9hppDyG/vnl4LmY
 fxtYRm0OhXXUMdWL/VyZGTKMKCI5r8d6DOQ6wQCBzeW7WX6Lu+IMnT+Oy1caFSCT5dsC
 718C054i49SUQbE9x6NJsJEDn6lLLrwuRxV0UaljFYZlbWLJqCPyj0nc/LxWs0+OL0Bl /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m77x1vhd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 11:30:00 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B2AvbW5007185
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 11:29:59 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m77x1vhcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 11:29:59 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B2BK4Va021107;
        Fri, 2 Dec 2022 11:29:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3m3ae8xkht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 11:29:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B2BTsSC10814190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Dec 2022 11:29:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10487A405F;
        Fri,  2 Dec 2022 11:29:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA05FA405B;
        Fri,  2 Dec 2022 11:29:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.31.115])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri,  2 Dec 2022 11:29:53 +0000 (GMT)
Date:   Fri, 2 Dec 2022 12:29:50 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        thuth@redhat.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for
 skey-related functions
Message-ID: <20221202122950.06265d20@p-imbrenda>
In-Reply-To: <d4af0699-e3e3-3a32-b963-b10beb390f7d@linux.ibm.com>
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
        <20221201084642.3747014-2-nrb@linux.ibm.com>
        <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com>
        <166997759426.186408.182395619403215562@t14-nrb.local>
        <d4af0699-e3e3-3a32-b963-b10beb390f7d@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pyGH7nUnod4sLcU7doRB4H5bwiJBcAhZ
X-Proofpoint-GUID: zpX6NHnlJgMWCifOijOSb98SazBKCqVV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=774 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212020086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Dec 2022 12:20:34 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 12/2/22 11:39, Nico Boehr wrote:
> > Quoting Janosch Frank (2022-12-02 10:03:22)  
> >> On 12/1/22 09:46, Nico Boehr wrote:  
> >>> Upcoming changes will add a test which is very similar to the existing
> >>> skey migration test. To reduce code duplication, move the common
> >>> functions to a library which can be re-used by both tests.
> >>>  
> >>
> >> NACK
> >>
> >> We're not putting test specific code into the library.  
> > 
> > What do you mean by "test specific"? After all, it is used by two tests now, possibly more in the future.
> > 
> > Any alternative suggestions?  
> 
> For me this is like putting kselftest macros/functions into the kernel.
> 
> The KUT library is more or less the kernel on which the tests in s390x/ 
> are based on. It provides primitives which (hopefully and mostly) aren't 
> specific to tests.
> 
> Yes:
> Providing skey set and get functions for one or multiple pages to tests.
> I.e. sske and iske wrappers.
> 
> No:
> Providing multi-page skey set and verify functions that set and verify 
> skeys based on a pattern which is __hardcoded__ into the function using 
> the skey wrappers. I.e. you're trying to create a new layer (test 
> functionality) and stuffing it into the unit test kernel library.
> 
> What you want is a separate testlib which would reside in s390x/testlib/ 
> where we can store often repeated functions and macros.

oufff, then we need to also fix the cmma migration tests
