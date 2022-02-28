Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A494C6748
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 11:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiB1KrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 05:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiB1KrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 05:47:23 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0EA5B888;
        Mon, 28 Feb 2022 02:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1646045206; x=1677581206;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=zzZ6qutMBuuKe1+IXK9e86iT6GdFnWh7RdZ05iZzSqw=;
  b=VNmuLkQD3UvXBsof9CmHApROGA8hC02Y1EkmbALWAE/EbQdzml7k/4i+
   XSHTTfrrE4PJrTvEwgcHjCSTeEbT5wY5jnYPSQtXyQ/oCNOVWU89+ecic
   NoLWdjfgdjQ54vP3tUbKGpIZAD61XiDrOJtl6pfQqiFYDWcUnKVXCCkjT
   8=;
X-IronPort-AV: E=Sophos;i="5.90,142,1643673600"; 
   d="scan'208";a="66671655"
Subject: Re: [PATCH 2/4] KVM: x86: hyper-v: Drop redundant 'ex' parameter from
 kvm_hv_flush_tlb()
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 28 Feb 2022 10:46:36 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com (Postfix) with ESMTPS id 87BF692DE8;
        Mon, 28 Feb 2022 10:46:35 +0000 (UTC)
Received: from 147dda3edfb6.ant.amazon.com (10.43.162.43) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 28 Feb 2022 10:46:31 +0000
Date:   Mon, 28 Feb 2022 11:46:27 +0100
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <YhyoA5Ebl5Tya8Ii@147dda3edfb6.ant.amazon.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
 <20220222154642.684285-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220222154642.684285-3-vkuznets@redhat.com>
X-Originating-IP: [10.43.162.43]
X-ClientProxiedBy: EX13D31UWA001.ant.amazon.com (10.43.160.57) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 04:46:40PM +0100, Vitaly Kuznetsov wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> 'struct kvm_hv_hcall' has all the required information already,
> there's no need to pass 'ex' additionally.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Siddharth Chandrasekaran <sidcha@amazon.de>



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



