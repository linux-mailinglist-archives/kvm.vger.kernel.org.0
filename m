Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9001892148
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 12:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfHSKbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 06:31:44 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:21854 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfHSKbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 06:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566210702; x=1597746702;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=iE0NNemVcAdpNEuhQpJ7J7AH4HxsWqskXskDpZuRxZQ=;
  b=h/+hClRieRI4s3RbEFAXYhw0I9JXcntVFTe7IknlLBqAX9kVpfItpXYd
   xMXQQvxcbL7GlB76EJaFQFb6l2lpEhE2jQ0nzNdghVJaIG11400OMkEDU
   ZFpyU4dBaHnjQbcsfk2HClU34QYrct0ecPmGH2xobdmEqO717U5sKF58Q
   U=;
X-IronPort-AV: E=Sophos;i="5.64,403,1559520000"; 
   d="scan'208";a="695087115"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 19 Aug 2019 10:31:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id A217DA07B3;
        Mon, 19 Aug 2019 10:31:30 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 10:31:30 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.214) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 10:31:27 +0000
Subject: Re: [PATCH v2 10/15] kvm: x86: hyperv: Use APICv deactivate request
 interface
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-11-git-send-email-suravee.suthikulpanit@amd.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <2b26daff-6970-cca4-8553-962a6d829bdd@amazon.com>
Date:   Mon, 19 Aug 2019 12:31:24 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565886293-115836-11-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D27UWA002.ant.amazon.com (10.43.160.30) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.08.19 18:25, Suthikulpanit, Suravee wrote:
> Since disabling APICv has to be done for all vcpus on AMD-based system,
> adopt the newly introduced kvm_make_apicv_deactivate_request() intereface.

typo

> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/hyperv.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a39e38f..4f71a39 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -772,9 +772,17 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
>   
>   	/*
>   	 * Hyper-V SynIC auto EOI SINT's are
> -	 * not compatible with APICV, so deactivate APICV
> +	 * not compatible with APICV, so  request

double space

> +	 * to deactivate APICV permanently.
> +	 *
> +	 * Since this requires updating
> +	 * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> +	 * also take srcu lock.
>   	 */
> -	kvm_vcpu_deactivate_apicv(vcpu);
> +	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	kvm_make_apicv_deactivate_request(vcpu, true);
> +	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);

Overall, I'm not terribly happy with the srcu locks. Can't we handle the 
memslot changes outside of the lock region, inside the respective 
request handlers somehow?


Alex

> +
>   	synic->active = true;
>   	synic->dont_zero_synic_pages = dont_zero_synic_pages;
>   	return 0;
> 
