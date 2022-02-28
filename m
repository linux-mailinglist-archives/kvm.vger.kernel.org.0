Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5D84C6746
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 11:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiB1KrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 05:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiB1KrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 05:47:10 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962865B885;
        Mon, 28 Feb 2022 02:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1646045193; x=1677581193;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=FI1/yOOeffy6joPkP+Ti8ba5rIGLgyw7EkCVE3fYaeY=;
  b=bzXTVCYdQT2JzDKGzPNKONQGUGVTx8NTGff3qgXKrNWDwBeRemPkQMDj
   v0lsfW6X3RF/qVBvf/VI76LxDbIGNd8rIN8hv0KQoEDZN3AGf78bBod+r
   jbLM6zdLv5ODHvv2ibGZ5j5oEwE9kqZpoZgAJsa3L0w9DVhSSYS6U4Gs2
   k=;
X-IronPort-AV: E=Sophos;i="5.90,142,1643673600"; 
   d="scan'208";a="66671572"
Subject: Re: [PATCH 1/4] KVM: x86: hyper-v: Drop redundant 'ex' parameter from
 kvm_hv_send_ipi()
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-05e8af15.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 28 Feb 2022 10:46:18 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-05e8af15.us-west-2.amazon.com (Postfix) with ESMTPS id B316FA2A1B;
        Mon, 28 Feb 2022 10:46:17 +0000 (UTC)
Received: from 147dda3edfb6.ant.amazon.com (10.43.161.89) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 28 Feb 2022 10:45:59 +0000
Date:   Mon, 28 Feb 2022 11:45:55 +0100
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <Yhyn4zXiFU4cnLSv@147dda3edfb6.ant.amazon.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
 <20220222154642.684285-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220222154642.684285-2-vkuznets@redhat.com>
X-Originating-IP: [10.43.161.89]
X-ClientProxiedBy: EX13D43UWC001.ant.amazon.com (10.43.162.69) To
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

On Tue, Feb 22, 2022 at 04:46:39PM +0100, Vitaly Kuznetsov wrote:
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



