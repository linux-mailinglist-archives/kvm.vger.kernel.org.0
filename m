Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CF84BE7C4
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379205AbiBUPbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 10:31:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379132AbiBUPbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 10:31:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7CA1EADC;
        Mon, 21 Feb 2022 07:30:39 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LEZnot030632;
        Mon, 21 Feb 2022 15:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WgZycox58fsYtKlQQbFRdVXd703jyRfjROOaii2dXxI=;
 b=oY1ud5+QJ2NI5yQJ7xV/7X0T4gZRsPPozUzGNRAT9MgCFq9Q+RngLcIYEsNaw3I544Fh
 t4/xDsuKMBc5duVEybtBrbHDd9CN/pQWDDU9IeBiDb3bVlzLUCGBZc3k9/M9DEj2DdLu
 RsVAYSyXA9qn9uVhLnojhUb3uHcdhAvHsjdd3CuBmBeNJnn2IZK+umYJGdAPHAhJnerE
 v03JXPpgBmkgCk1Mmrb2vf7/QDcpIoVE7d3hTY23ELU+jobNOBOesqsZfkK8khK/vCwu
 2dKoHx2vEWSC9QkgraiEmoB1mEAwautekNAm4o+O+Ao/4bucZWBADICg88G7x3lyp71C fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ec0eu8aae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 15:30:39 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LEoOOS032474;
        Mon, 21 Feb 2022 15:30:38 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ec0eu8a9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 15:30:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LFCvLX013525;
        Mon, 21 Feb 2022 15:30:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ear68up01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 15:30:36 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LFUWCd44630520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 15:30:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF0135204E;
        Mon, 21 Feb 2022 15:30:32 +0000 (GMT)
Received: from [9.145.32.243] (unknown [9.145.32.243])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9285552057;
        Mon, 21 Feb 2022 15:30:32 +0000 (GMT)
Message-ID: <0bb8a574-059c-f356-fcd1-74d0bc41fa1a@linux.ibm.com>
Date:   Mon, 21 Feb 2022 16:30:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests PATCH v2 0/8] s390x: Extend instruction
 interception tests
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com
References: <20220221130746.1754410-1-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220221130746.1754410-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iyPC6vc6scEMOF6Q07XiFU7uE01Cgevn
X-Proofpoint-ORIG-GUID: CgoUOab80u_P-mPiDmO5Siag8ZS7bRjC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202210089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/22 14:07, Nico Boehr wrote:
> This series extends the instruction interception tests for s390x.
> 
> For most instructions, there is already coverage in existing tests, but they are
> not covering some failure cases, e.g. bad alignment. In this case, the existing
> tests were extended.
> 
> SCK was not under test anywhere yet, hence a new test file was added.
> 
> The EPSW test gets it's own file, too, because it requires a I/O device, more
> details in the respective commit.

Could you please push this to devel so we can get CI data?

To me it seems like only STSCH needs review so we should be done with 
this soonish.


> 
> Changelog from v1:
> ----
> - Reset pmcw flags at test end
> - Rebase
> 
> Nico Boehr (8):
>    s390x: Add more tests for MSCH
>    s390x: Add test for PFMF low-address protection
>    s390x: Add sck tests
>    s390x: Add tests for STCRW
>    s390x: Add more tests for SSCH
>    s390x: Add more tests for STSCH
>    s390x: Add tests for TSCH
>    s390x: Add EPSW test
> 
>   lib/s390x/css.h     |  17 +++
>   lib/s390x/css_lib.c |  60 ++++++++++
>   s390x/Makefile      |   2 +
>   s390x/css.c         | 278 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/epsw.c        | 113 ++++++++++++++++++
>   s390x/pfmf.c        |  29 +++++
>   s390x/sck.c         | 127 ++++++++++++++++++++
>   s390x/unittests.cfg |   7 ++
>   8 files changed, 633 insertions(+)
>   create mode 100644 s390x/epsw.c
>   create mode 100644 s390x/sck.c
> 

