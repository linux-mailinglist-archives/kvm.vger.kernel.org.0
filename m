Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC295652489
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 17:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiLTQUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 11:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiLTQUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 11:20:04 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390D81C919
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:20:02 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGBWpJ017856
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 16:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sDfF53G5JGK8pqNtX5oSa26XYOPjvUrKmjazy7pILT4=;
 b=ahYJiOdHHo0Lzw7D8+Q1/dwrI7eKjl98PK0+UqXoatyN+xNl9OMsXFALIBl3B8MVsMqq
 nZ46vkTkldeR8EmtNFwIlJInhN+W9/YJaXhL5kU90wl57h+5+y6sB7iMxtND1SuUN2dL
 ig3uaMNlt//WRL84GqGZJOPOb3mmAZZSpIhG1Df/wlsEQsm+0Bzw6Ws6OubEw+P2whbK
 e0WjjMER7jl0wldlcl/fuKVrehIEA958ctwXVnNZterL82oO1Bg3kgCqnpHJtx+rx66q
 lJ1yNZlspLdiBU4DpB8rlMxtobwmFX5fO6BPCSvgyWAgcVfsTMdKPBGNl2xY3rrPpzbU Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgbsraqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 16:20:01 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKGC49g023542
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 16:20:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgbsraq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 16:20:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK6H6ga014024;
        Tue, 20 Dec 2022 16:19:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yw49ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 16:19:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKGJtOm46399760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 16:19:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 052782005A;
        Tue, 20 Dec 2022 16:19:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B607F20049;
        Tue, 20 Dec 2022 16:19:54 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.2.112])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
        Tue, 20 Dec 2022 16:19:54 +0000 (GMT)
Date:   Tue, 20 Dec 2022 17:19:53 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v5 1/1] s390x: add CMM test during
 migration
Message-ID: <20221220171953.41195228@p-imbrenda>
In-Reply-To: <20221220091923.69174-2-nrb@linux.ibm.com>
References: <20221220091923.69174-1-nrb@linux.ibm.com>
        <20221220091923.69174-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2DCu7bqCJSG3nuQgeQz0SFls3IIYtxVu
X-Proofpoint-GUID: Lj5wqJxaf7Wp6wUP4n8DP0iHqT3UlRg2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=907 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212200133
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Dec 2022 10:19:23 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Add a test which modifies CMM page states while migration is in
> progress.
> 
> This is added to the existing migration-cmm test, which gets a new
> command line argument for the sequential and parallel variants.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---

[...]

> +
> +[migration-cmm-sequential]
> +file = migration-cmm.elf
> +groups = migration
> +extra_params = -append '--sequential'
> +
> +[migration-cmm-parallel]
> +file = migration-during-cmm.elf

this should actually be migration-cmm.elf

> +groups = migration
> +smp = 2
> +extra_params = -append '--parallel'

