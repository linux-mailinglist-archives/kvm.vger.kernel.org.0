Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7117F2606E0
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 00:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgIGWWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 18:22:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35038 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726938AbgIGWWg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 18:22:36 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087M2P64119530;
        Mon, 7 Sep 2020 18:22:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BKqn82UHhNA5lY4QEpaNef4h2jnXBhjIPPiSrCQfmcY=;
 b=PWxlkKxNujSnpkkcIN7bj2u8K5bbsowcRTIdj5OzOWZHYAEBXytTkH5qz433DKCog+10
 hdtrdtKkpHpPOuYFmg5wQmKRUi+zdDXWo9Buo371gACiX0YDAIPK72QB2fljD6Px8Cu2
 6EHscGJIdbK9+AwHr8VL658ie4HzIQ8PkqRGSYQ7gUXFKW3vV/EeLumhA+W7hNnvo9jn
 OSYOkh5vwnnoWl4p7uaq5X8zbqiBkM51c9lOgdRg2xavglPTuCN+vXlEXYf6BFyt4mPS
 0SLx354GpV3CBT3yHMUj37tnCfwO36PNsVaFPny2Hx7ar8RnsgrIdOJRqLk6UMFkNrXt Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33du2pb43v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 18:22:25 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 087M2QPx119576;
        Mon, 7 Sep 2020 18:22:24 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33du2pb43k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 18:22:24 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 087MMNsF031057;
        Mon, 7 Sep 2020 22:22:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 33cyq51hn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 22:22:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 087MMKhK33816896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Sep 2020 22:22:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E7F5A4051;
        Mon,  7 Sep 2020 22:22:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68E18A4053;
        Mon,  7 Sep 2020 22:22:19 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.173.93])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Sep 2020 22:22:19 +0000 (GMT)
Date:   Tue, 8 Sep 2020 00:22:12 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 1/2] virtio: let arch advertise guest's memory
 access restrictions
Message-ID: <20200908002212.462303b4.pasic@linux.ibm.com>
In-Reply-To: <1599471547-28631-2-git-send-email-pmorel@linux.ibm.com>
References: <1599471547-28631-1-git-send-email-pmorel@linux.ibm.com>
        <1599471547-28631-2-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_11:2020-09-07,2020-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1011 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=977 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070207
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  7 Sep 2020 11:39:06 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> An architecture may restrict host access to guest memory,
> e.g. IBM s390 Secure Execution or AMD SEV.
> 
> Provide a new Kconfig entry the architecture can select,
> CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS, when it provides
> the arch_has_restricted_virtio_memory_access callback to advertise
> to VIRTIO common code when the architecture restricts memory access
> from the host.
> 
> The common code can then fail the probe for any device where
> VIRTIO_F_ACCESS_PLATFORM is required, but not set.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

[..]
>  
> +config ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS
> +	bool
> +	help
> +	  This option is selected if the architecture may need to enforce
> +	  VIRTIO_F_IOMMU_PLATFORM.
> +

A small nit: you use F_ACCESS_PLATFORM everywhere but here.

Regards,
Halil
