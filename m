Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597B24D0022
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 14:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiCGNdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 08:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbiCGNdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 08:33:37 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D592E25E90;
        Mon,  7 Mar 2022 05:32:42 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227DLgtR025057;
        Mon, 7 Mar 2022 13:32:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=qAahZCmlelT+0C/V8HEmzpjOfEfmCvoYYffYEaXRD+E=;
 b=T3Zhay7aRiUBmx8gbVXEaUO0brIGt0GlJWzMM3B+k2L3ohSClcwbgK9G9YIExK3n2EME
 qk3iPTBMMu542caqdWSCY+MiPePxRmV6fbC189Aqz6mfNnAm5SAX4Mte+fOHwAHTSRIg
 FJ2/K4/HedsOnYbtihDE3pfvw2pba9MB9nrGw+juyKY+Krc6R/rmISFH/PQiH/saFSJP
 P0ZYBMqAcdM3//68xO6W+sven0GPbuYE7qs5XDYHiVexgypHWBFuJatV2iVWijkQMyUy
 ODO+4Kt7vUNRsAfGOwxLOYS901sMarwIkCZF8D0ZcVjERfL7ocD+ENYZCCCFE59i2QmW Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enjv8g52c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 13:32:41 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227DMwI2030417;
        Mon, 7 Mar 2022 13:32:40 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enjv8g4hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 13:32:40 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227DCQDK011540;
        Mon, 7 Mar 2022 13:31:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3ekyg8c33f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 13:31:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227DV8wJ55706016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 13:31:08 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E51CD42045;
        Mon,  7 Mar 2022 13:31:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95F9F4203F;
        Mon,  7 Mar 2022 13:31:07 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.55.208])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 13:31:07 +0000 (GMT)
Message-ID: <1342ba11026d58fecf4e596a0e3942076ef53051.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 4/6] s390x: smp: Create and use a
 non-waiting CPU stop
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 07 Mar 2022 14:31:07 +0100
In-Reply-To: <20220303210425.1693486-5-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-5-farman@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6afP1_SwHryxR-fLYIY4pSl9gBdbe_S9
X-Proofpoint-ORIG-GUID: rXMk_aqfgl5BKUQZnpfnkJsbP-6pMwqK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_05,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 impostorscore=0
 mlxlogscore=892 bulkscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070078
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
[...]

> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -76,14 +76,8 @@ static void test_restart(void)
>  
>  static void test_stop(void)
>  {
> -       smp_cpu_stop(1);
> -       /*
> -        * The smp library waits for the CPU to shut down, but let's
> -        * also do it here, so we don't rely on the library
> -        * implementation
> -        */
> -       while (!smp_cpu_stopped(1)) {}
> -       report_pass("stop");
> +       smp_cpu_stop_nowait(1);

Now that this can fail because of CC=2, should we check the return
value here?
