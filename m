Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C1252A086
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345320AbiEQLh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345307AbiEQLhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:37:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40F63BBFA;
        Tue, 17 May 2022 04:37:23 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBW4HS002994;
        Tue, 17 May 2022 11:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4LACMKjXXZJEtLLWWpfkf1KmYX/WiN/HfbfpSFvvFj8=;
 b=YTCIdge9jA80NV7O6dk3aHmuvUGn1OiGHLC0r/Pw/q8T12iCLyjlbFAnyFVPMySf9qeN
 j+4q2TZaEJ/UpvUlJGeUmHIfclqphGvP2FnpF3p3/T6QOkrG8KfMLzjW0BemSjcQ+bt8
 ulNy+4f2wcqnCpqxD9kzDiTPMBRmWw5vkDUCHM9CI3Y2pVcz/mgD+07C+bZz5l6hPqlJ
 f0EV08XRNW6B0P1wHgCHB6X0eYvM5y7VrmtXZoS1ga3tDu66/dCbAc+sIahaHSBOXM2I
 Cns1H2YDTOFj4NQZgN1KUJ0aMGKkUYa8kHF5sKiDNCzfIkS15OudbTUB3d8KQiR+E6Wd fw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4awv03a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:37:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBHwdj019606;
        Tue, 17 May 2022 11:37:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjc4pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:37:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBNStF26738948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:23:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07823A405B;
        Tue, 17 May 2022 11:37:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBAEBA4054;
        Tue, 17 May 2022 11:37:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:37:17 +0000 (GMT)
Date:   Tue, 17 May 2022 12:59:44 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v5 05/10] KVM: s390: pv: Add query dump information
Message-ID: <20220517125944.76c6619e@p-imbrenda>
In-Reply-To: <20220516090817.1110090-6-frankja@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
        <20220516090817.1110090-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qoq7EhH0bgBq5rvC04d8DwUgLPOHjTkd
X-Proofpoint-ORIG-GUID: qoq7EhH0bgBq5rvC04d8DwUgLPOHjTkd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205170068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 May 2022 09:08:12 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The dump API requires userspace to provide buffers into which we will
> store data. The dump information added in this patch tells userspace
> how big those buffers need to be.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 11 +++++++++++
>  include/uapi/linux/kvm.h | 12 +++++++++++-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 5859f243d287..de54f14e081e 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2255,6 +2255,17 @@ static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
>  
>  		return len_min;
>  	}
> +	case KVM_PV_INFO_DUMP: {
> +		len_min =  sizeof(info->header) + sizeof(info->dump);
> +
> +		if (info->header.len_max < len_min)
> +			return -EINVAL;
> +
> +		info->dump.dump_cpu_buffer_len = uv_info.guest_cpu_stor_len;
> +		info->dump.dump_config_mem_buffer_per_1m = uv_info.conf_dump_storage_state_len;
> +		info->dump.dump_config_finalize_len = uv_info.conf_dump_finalize_len;
> +		return len_min;
> +	}
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8ac9de7d1386..bb2f91bc2305 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1655,6 +1655,13 @@ struct kvm_s390_pv_unp {
>  
>  enum pv_cmd_info_id {
>  	KVM_PV_INFO_VM,
> +	KVM_PV_INFO_DUMP,
> +};
> +
> +struct kvm_s390_pv_info_dump {
> +	__u64 dump_cpu_buffer_len;
> +	__u64 dump_config_mem_buffer_per_1m;
> +	__u64 dump_config_finalize_len;
>  };
>  
>  struct kvm_s390_pv_info_vm {
> @@ -1674,7 +1681,10 @@ struct kvm_s390_pv_info_header {
>  
>  struct kvm_s390_pv_info {
>  	struct kvm_s390_pv_info_header header;
> -	struct kvm_s390_pv_info_vm vm;
> +	union {
> +		struct kvm_s390_pv_info_dump dump;
> +		struct kvm_s390_pv_info_vm vm;
> +	};
>  };
>  
>  enum pv_cmd_id {

