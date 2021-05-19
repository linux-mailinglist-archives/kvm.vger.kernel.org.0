Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9A6388B84
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 12:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347721AbhESKS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 06:18:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33420 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345378AbhESKS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 06:18:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JA5ATk111744;
        Wed, 19 May 2021 10:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hGk2Jt4LTPzO1S2qngYtkz7Cl2+5Qs1xMzLMoopxFvM=;
 b=ttyC7XAEgInr/OmPK6WCkIceXQvVsWucEMfbcxdKhW/9z791xwEt+tjTFhTaqXeBLZY9
 uNzvEUgitVBoYKI0x7sOkl9HH33B1MiWnotnr5QbsimtBXOQh62eVIexGWROYjejBULY
 lIlNLCpc8v7C+oymJs+erxTRYJaXkIX5wkxibCSrW/+IKbODJhmHlrjt6zd0jK3+J5Yb
 8/WogueggqkrAFq3/Fk516fjwerQoBxH6vdFZ4RX3Rw8ELEq0j4pCcJqjTTPikNv1LTj
 nvUJKS+tR/BXssO/pOrWqkZT47wLQ6EO7wcVFZLAoK1fD4PXbcWBBlM/fFE1TCyD5u/O iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38j5qr93g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 10:17:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JA5w25046922;
        Wed, 19 May 2021 10:17:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38mechqq6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 10:17:18 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14JAHH4o129654;
        Wed, 19 May 2021 10:17:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 38mechqq5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 10:17:17 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14JAHFgb015636;
        Wed, 19 May 2021 10:17:15 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 03:17:14 -0700
Date:   Wed, 19 May 2021 13:17:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH v18 02/18] RISC-V: Add initial skeletal KVM support
Message-ID: <20210519101704.GT1955@kadam>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
 <20210519033553.1110536-3-anup.patel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519033553.1110536-3-anup.patel@wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: 6jRe5b4YCQkMwwXaSxJBXaR3mYMvI9hZ
X-Proofpoint-ORIG-GUID: 6jRe5b4YCQkMwwXaSxJBXaR3mYMvI9hZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 09:05:37AM +0530, Anup Patel wrote:
> +void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
> +{
> +	/* TODO: */
> +}
> +

I was disappointed how many stub functions remained at the end of the
patchset...  It's better to not publish those.  How useful is this
patchset with the functionality that is implemented currently?

> +int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> +{
> +	int r;
> +
> +	r = kvm_riscv_stage2_alloc_pgd(kvm);
> +	if (r)
> +		return r;
> +
> +	return 0;
> +}

Half the code uses "int ret;" and half uses "int r;".  Make everything
int ret.

regards,
dan carpenter
