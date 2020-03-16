Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD4C186A9D
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 13:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbgCPMKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 08:10:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11696 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730844AbgCPMKT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 08:10:19 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GC3Y4v004835
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 08:10:17 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yrt33vemh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 08:10:17 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Mon, 16 Mar 2020 12:10:15 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 16 Mar 2020 12:10:13 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02GCACqK50725066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 12:10:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62AA64C05C;
        Mon, 16 Mar 2020 12:10:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A1304C046;
        Mon, 16 Mar 2020 12:10:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.61])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Mar 2020 12:10:11 +0000 (GMT)
Date:   Mon, 16 Mar 2020 13:10:09 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] KVM: s390: mark sie block as 512 byte aligned
In-Reply-To: <20200311083304.3725276-1-borntraeger@de.ibm.com>
References: <20200311083304.3725276-1-borntraeger@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20031612-0020-0000-0000-000003B5412B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031612-0021-0000-0000-0000220DA072
Message-Id: <20200316131009.381a8692@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-16_03:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=744 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003160058
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Mar 2020 09:33:04 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> The sie block must be aligned to 512 bytes. Mark it as such.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h
> b/arch/s390/include/asm/kvm_host.h index 0ea82152d2f7..2d50f6c432e2
> 100644 --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -344,7 +344,7 @@ struct kvm_s390_sie_block {
>  	__u64	itdba;			/* 0x01e8 */
>  	__u64   riccbd;			/* 0x01f0 */
>  	__u64	gvrd;			/* 0x01f8 */
> -} __attribute__((packed));
> +} __packed __aligned(512);
>  
>  struct kvm_s390_itdb {
>  	__u8	data[256];

I agree with the addition of aligned, but did you really have to remove
packed? it makes me a little uncomfortable.

do we have any compile-time assertions that the size of the block will
be the one we expect?

