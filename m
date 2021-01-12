Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D472F298E
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 08:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbhALH6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 02:58:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9824 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731707AbhALH6A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 02:58:00 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10C7gPFe154953;
        Tue, 12 Jan 2021 02:57:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SEOB9Qhvq1iCXBxaz4aEhUoxh8MtQygds2qy/445Ho0=;
 b=Q2uZKpYoYdm90meAYX4X4NroYGZj5rKoqyviQ47cmwM9Pjt514JkfTQtcX1FWZ6aIyYq
 k7TGb1fnuR28uB+AdYFSub6JglCjg0UyuDGfQKEfDgpG9k5zGALTVB640WnaqmTWw2ur
 e1edTi883w81PcXe8lYJ3xOQwCtPwBVPF7DRIVgntI/tiSQl6n4mAnxgo66++wccsSuv
 zsW9wANWS1Tc/4UD1jBfDUTumZM8yl6L8wkkEZj/TAYwvg9T3xyqqURszu6SLCLc6L1z
 Mpv8ADd4mJVo1gOi8LzpXoGOAGIsPRDPp9JzCnUhof4F2SWTgWF+feqaN8LWZoF655SZ Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3617m089yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 02:57:00 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10C7hs2k158115;
        Tue, 12 Jan 2021 02:57:00 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3617m089xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 02:57:00 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10C7mA3o012498;
        Tue, 12 Jan 2021 07:56:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 35y448hp3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 07:56:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10C7utD926083724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 07:56:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 241454C04A;
        Tue, 12 Jan 2021 07:56:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 240AA4C040;
        Tue, 12 Jan 2021 07:56:54 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.50.44])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 07:56:54 +0000 (GMT)
Subject: Re: [PATCH v6 10/13] spapr: Add PEF based confidential guest support
To:     David Gibson <david@gibson.dropbear.id.au>, pasic@linux.ibm.com,
        brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        qemu-devel@nongnu.org
Cc:     andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, mdroth@linux.vnet.ibm.com,
        richard.henderson@linaro.org, kvm@vger.kernel.org,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-11-david@gibson.dropbear.id.au>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <7d8775df-b3fb-deff-44f2-2e41c83a67ca@de.ibm.com>
Date:   Tue, 12 Jan 2021 08:56:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210112044508.427338-11-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_03:2021-01-11,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120037
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12.01.21 05:45, David Gibson wrote:
[...]
> diff --git a/include/hw/ppc/pef.h b/include/hw/ppc/pef.h
> new file mode 100644
> index 0000000000..7c92391177
> --- /dev/null
> +++ b/include/hw/ppc/pef.h
> @@ -0,0 +1,26 @@
> +/*
> + * PEF (Protected Execution Facility) for POWER support
> + *
> + * Copyright David Gibson, Redhat Inc. 2020
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory.
> + *
> + */
> +
> +#ifndef HW_PPC_PEF_H
> +#define HW_PPC_PEF_H
> +
> +int pef_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
> +
> +#ifdef CONFIG_KVM
> +void kvmppc_svm_off(Error **errp);
> +#else
> +static inline void kvmppc_svm_off(Error **errp)
> +{
> +}
> +#endif
> +
> +
> +#endif /* HW_PPC_PEF_H */
> +

In case you do a respin, 

git am says
Applying: confidential guest support: Update documentation
Applying: spapr: Add PEF based confidential guest support
.git/rebase-apply/patch:254: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
Applying: spapr: PEF: prevent migration


