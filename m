Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C546C34CC
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 15:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjCUOxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 10:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjCUOxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 10:53:31 -0400
Received: from out-14.mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0F55BA5
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 07:53:30 -0700 (PDT)
Date:   Tue, 21 Mar 2023 15:53:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679410408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v7nt2ZcLJI8v874JEFEjYqSymW12b5rJowFOtO9NW+s=;
        b=a+wfCfzb7+0szC1XzKTnNenvmBweKKpql/zf6uP0rwrey2NFzQ/HB3kibfl114mn8CYK4I
        CbqIbIQZ24Wf1W62V28WtzSAcWYSS/CNQEFecyaM1XuPUwv2q/1BJUJBSD/IDuw0+cB2GH
        3fI+oEds7aY/76gwmjP6XwcqF5khQjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org
Subject: Re: [kvm-unit-tests PATCH v10 2/7] add .gitpublish metadata
Message-ID: <20230321145327.oetnj7ao7jxjp5ac@orel>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230307112845.452053-3-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230307112845.452053-3-alex.bennee@linaro.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023 at 11:28:40AM +0000, Alex Bennée wrote:
> This allows for users of git-publish to have default routing for kvm
> and kvmarm patches.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  .gitpublish | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>  create mode 100644 .gitpublish
> 
> diff --git a/.gitpublish b/.gitpublish
> new file mode 100644
> index 00000000..39130f93
> --- /dev/null
> +++ b/.gitpublish
> @@ -0,0 +1,18 @@
> +#
> +# Common git-publish profiles that can be used to send patches to QEMU upstream.
> +#
> +# See https://github.com/stefanha/git-publish for more information
> +#
> +[gitpublishprofile "default"]
> +base = master
> +to = kvm@vger.kernel.org
> +cc = qemu-devel@nongnu.org
> +cccmd = scripts/get_maintainer.pl --noroles --norolestats --nogit --nogit-fallback 2>/dev/null
> +
> +[gitpublishprofile "arm"]
> +base = master
> +to = kvmarm@lists.cs.columbia.edu
> +cc = kvm@vger.kernel.org
> +cc = qemu-devel@nongnu.org
> +cc = qemu-arm@nongnu.org
> +cccmd = scripts/get_maintainer.pl --noroles --norolestats --nogit --nogit-fallback 2>/dev/null

Should we also set the prefix for these?

 prefix = kvm-unit-tests PATCH

And maybe even, 'signoff = true'?

Otherwise,

Acked-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
