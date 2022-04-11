Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BED94FBC9F
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 14:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346283AbiDKNBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 09:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345215AbiDKNBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 09:01:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B7718E3E;
        Mon, 11 Apr 2022 05:59:22 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BBVqnL003674;
        Mon, 11 Apr 2022 12:59:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vt6ixBYBGNkUvmFCbsopzEFdpwEgLtB6vyiNUUT3mfI=;
 b=iDvZ5HSxFjqNcHDtCV4vyZh+P1YeyYmk+HdH4V/MPpHM/OGuB+88dOGQCi3zf2I+9qHY
 PRusRoE8u1a3KXtihP2ZaQRDhVQ4M/UNgmrMzfuDrsql47GaEBMB15YcmZrnQOF2qroL
 Qo5DsnQcY08M995sFNKcUk42Ea00lcXHAQDti1F29DTOOthUXeq2JJBKdYxXWWjyTuI5
 s03V0ZPW4O9Zb54a0FbHZch2Qf+3WVG3D2FPrQlviPy2kcoaDWfhODiq6vMmPyrGr3SQ
 ps0eewgeqS1DSfxa9j8qFHAW4kmcPEEi2mMM+cD5qaEQHOcHavOpqwkoDVNbSr5+miFs xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fckhssw6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:59:21 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23BBr5HS035519;
        Mon, 11 Apr 2022 12:59:21 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fckhssw6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:59:21 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BCrg6Y008611;
        Mon, 11 Apr 2022 12:59:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3fb1dj35md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:59:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BCxGP246268892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 12:59:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98E7D4C040;
        Mon, 11 Apr 2022 12:59:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F0F54C044;
        Mon, 11 Apr 2022 12:59:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.140])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 12:59:16 +0000 (GMT)
Date:   Mon, 11 Apr 2022 14:58:57 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/4] s390x: add support for migration
 tests
Message-ID: <20220411145857.0a99b511@p-imbrenda>
In-Reply-To: <20220411100750.2868587-3-nrb@linux.ibm.com>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
        <20220411100750.2868587-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: g34Hv3yq_BEwFUVe5d1UBix3r-rhU1mC
X-Proofpoint-GUID: 0Z4NA4OiWuvBXJRvD1x6bcGwJp92jjb_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_04,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Apr 2022 12:07:48 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Now that we have SCLP console read support, run our tests with migration_cmd, so
> we can get migration support on s390x.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/run | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/run b/s390x/run
> index 064ecd1b337a..2bcdabbaa14f 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -25,7 +25,7 @@ M+=",accel=$ACCEL"
>  command="$qemu -nodefaults -nographic $M"
>  command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
>  command+=" -kernel"
> -command="$(timeout_cmd) $command"
> +command="$(migration_cmd) $(timeout_cmd) $command"
>  
>  # We return the exit code via stdout, not via the QEMU return code
>  run_qemu_status $command "$@"

