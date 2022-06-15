Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8DF54C007
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 05:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345962AbiFODOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 23:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiFODO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 23:14:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011564BBAF;
        Tue, 14 Jun 2022 20:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655262868; x=1686798868;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i+WYowtZfnA4X7A1Nw8M91gitUFURnIVbLA9YC1Q694=;
  b=Wd5sfVIuU9FyMdAFNizMJxTE9EFvWYlHUxRLKkLNmW05Q+QV9pmK1HW4
   pLqv7w36uY3XudhPCLNL2QmkS0Uf6dfV7ZFnHABSzERdwoUaEYUAIK+Xh
   hZAiO8OqHgzt6u1Nx5s/hAI3vupohxgUDehYLYeClNHL4dUOQhBNKh+zc
   ZfjVqnNFz+Oo3g1xqkSLp8eSD1o2g3sZY0OmZP9UluKpA9+9l55Lhnjmj
   haRhKgg7GGCuJHJpgPr+gTifThI71i67h12KY2vMBac/zWKi1yTYDALqD
   9i9tFiD+uH+m8zH9dDYCw4MqPfx4prZq274N3Y6uSYGwq1W920iUk56ML
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="340479159"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="340479159"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 20:14:27 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="640741626"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 20:14:25 -0700
Date:   Wed, 15 Jun 2022 11:14:12 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 7/7] KVM: selftests: Add tests for VM and vCPU cap
 KVM_CAP_X86_DISABLE_EXITS
Message-ID: <20220615031407.GC7808@gao-cwp>
References: <20220615011622.136646-1-kechenl@nvidia.com>
 <20220615011622.136646-8-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615011622.136646-8-kechenl@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>+/* Set debug control for trapped instruction exiting to userspace */
>+static void vcpu_set_debug_exit_userspace(struct kvm_vm *vm, int vcpuid,
>+		struct kvm_guest_debug *debug) {

The debug argument looks pointless. Probably you can remove it.

>+	memset(debug, 0, sizeof(*debug));
>+	debug->control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_EXIT_USERSPACE;
>+	vcpu_set_guest_debug(vm, VCPU_ID_1, debug);
>+}
