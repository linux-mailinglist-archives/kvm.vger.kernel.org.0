Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302B94FBCA1
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 14:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346294AbiDKNBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 09:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiDKNBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 09:01:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E79B193C0;
        Mon, 11 Apr 2022 05:59:26 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BCBtbb018716;
        Mon, 11 Apr 2022 12:59:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=T+x58+EKa/ph1eEoaOo/a9Z0kB6U9j9fkwtUPkdJdHE=;
 b=Y3dsG1VHVvYZSQbEqyk9d3DPq15FaPel+9fbqu1pcxeDwrsDhksLhrjwlsMtILr+Oz6d
 Habb1RcyrV2k7K7lQ4+GnJ/MPsmyYhoVr3I32Jydnd2o5Wj2//OugdseUmMYcQLrsJS1
 45wcfN0p82uL2WuagYegSUKidhHI6RBtrNrHXEpiN0jD7yyaxC6s8Tk6JtGXrCvkm8X3
 Poq4iz5rlmXKGHv0Kmib19z6JxdKveZ3sgE556G1DncJjodrGol/gx2yg23HHBwJGSdk
 WtXX2kZHv0uH58/4I4ZkD9RVfJe6C4brHU5COX2dK+bH5t5gy1GbAMyPnqJsj+jRDglq Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcm4cry4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:59:24 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23BCDXwS022611;
        Mon, 11 Apr 2022 12:59:24 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcm4cry42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:59:23 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BCrg6Z008611;
        Mon, 11 Apr 2022 12:59:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3fb1dj35mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:59:21 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BCxIjI38404492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 12:59:18 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A7A14C046;
        Mon, 11 Apr 2022 12:59:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ACAE4C04A;
        Mon, 11 Apr 2022 12:59:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.140])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 12:59:18 +0000 (GMT)
Date:   Mon, 11 Apr 2022 14:58:43 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: don't run migration tests
 under PV
Message-ID: <20220411145843.3a3de529@p-imbrenda>
In-Reply-To: <20220411100750.2868587-4-nrb@linux.ibm.com>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
        <20220411100750.2868587-4-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M_4P9_aVjNrfBAIE6OMgHhMXTuu5Mr-u
X-Proofpoint-ORIG-GUID: CieY2MOlDjKChKsZ4K1e4ZEf2jfivBdF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_04,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Apr 2022 12:07:49 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> PV doesn't support migration, so don't run the migration tests there.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/run               | 5 +++++
>  scripts/s390x/func.bash | 2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/run b/s390x/run
> index 2bcdabbaa14f..24138f6803be 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -20,6 +20,11 @@ if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$ACCEL" = "
>  	exit 2
>  fi
>  
> +if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$MIGRATION" = "yes" ]; then
> +	echo "Migration isn't supported under Protected Virtualization"
> +	exit 2
> +fi
> +
>  M='-machine s390-ccw-virtio'
>  M+=",accel=$ACCEL"
>  command="$qemu -nodefaults -nographic $M"
> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> index bf799a567c3b..2a941bbb0794 100644
> --- a/scripts/s390x/func.bash
> +++ b/scripts/s390x/func.bash
> @@ -21,7 +21,7 @@ function arch_cmd_s390x()
>  	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>  
>  	# run PV test case
> -	if [ "$ACCEL" = 'tcg' ]; then
> +	if [ "$ACCEL" = 'tcg' ] || find_word "migration" "$groups"; then
>  		return
>  	fi
>  	kernel=${kernel%.elf}.pv.bin

