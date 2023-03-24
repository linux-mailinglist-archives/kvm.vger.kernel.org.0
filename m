Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEA76C7C45
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 11:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjCXKLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 06:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjCXKL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 06:11:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206D626CEB;
        Fri, 24 Mar 2023 03:11:18 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32O8noOg023807;
        Fri, 24 Mar 2023 10:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=FNofbkM5/he4zVHJN8MD3GM+MKom8lsiALn0ZYbs7CY=;
 b=nFyBrUHYzDapMBKNdCLaOJlMJIil1sguEIA3wWn47SXtLCxsKxgfSUxYLzXZeMhlrdHB
 eeGD3Qr3pPnGQv2s6otgyCHC9+mOjzHUIdwzSOdKp+pfljaW2rBMsU7kdvCyFDFkXHej
 UcQcGUE+0CiBhfIJ/sJid3aKO/Hvc2PkXbeb69M/pXgoUmB8E8nBsW2BTW5hb/4SNV4U
 Pw08dGtF3sL4Tas6gOMxWbynjfW5TzdfmTeVUHH2osOZ3Z990VP0FcmXekJvVaj5jaYR
 pgSZGmXOesVFQZ3oFRdtejqQh20vKKiBSiCOhD5WrzTGt9i2+JiDYfK5OP6a32O/InAv Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph8pu1wk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 10:11:18 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OA6IBX017623;
        Fri, 24 Mar 2023 10:11:17 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph8pu1wj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 10:11:17 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLKhFG024778;
        Fri, 24 Mar 2023 10:11:15 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pgxkrrpcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 10:11:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OABClu41878246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 10:11:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1973B201DF;
        Fri, 24 Mar 2023 10:11:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6DB0201DC;
        Fri, 24 Mar 2023 10:11:11 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.14.197])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 10:11:11 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230320085642.12251-2-pmorel@linux.ibm.com>
References: <20230320085642.12251-1-pmorel@linux.ibm.com> <20230320085642.12251-2-pmorel@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v7 1/2] s390x: topology: Check the Perform Topology Function
Message-ID: <167965267156.41638.18125355247583778957@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 24 Mar 2023 11:11:11 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cQcRyIPPUGCo7dxoR_3pxXw04E7_CqQk
X-Proofpoint-ORIG-GUID: eNdmFc7qomPXFcS7AaEfmHbOskP43TG3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_05,2023-03-23_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-03-20 09:56:41)
[...]
> diff --git a/s390x/topology.c b/s390x/topology.c
> new file mode 100644
> index 0000000..ce248f1
> --- /dev/null
> +++ b/s390x/topology.c
> @@ -0,0 +1,180 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/facility.h>
> +#include <smp.h>
> +#include <sclp.h>
> +#include <s390x/hardware.h>
> +
> +#define PTF_REQ_HORIZONTAL     0
> +#define PTF_REQ_VERTICAL       1
> +#define PTF_REQ_CHECK          2

These are all function codes, so how about we name these defines PTF_FC_...

and since PTF_REQ_CHECK doesn't request anything we should rename to PTF_FC=
_CHECK

[...]
> +static struct {
> +       const char *name;
> +       void (*func)(void);
> +} tests[] =3D {
> +       { "PTF", test_ptf},
missing space              ^
