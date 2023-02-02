Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCB4688699
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjBBSfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbjBBSfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:35:10 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE2538E9A;
        Thu,  2 Feb 2023 10:34:34 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id EF07F7DE;
        Thu,  2 Feb 2023 18:33:13 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net EF07F7DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1675362794; bh=J2JY+T5iM+FGyaREIvdJEYNp+CLOeUmGJfIw7hyF1Dg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=l0JzSHXkaFIqIZ+qFIfRFCXtSo7Jn3y7j6YrvVYkhGLQk0vhcXCm8k56PjwOl+T/s
         YkTCUbM8aFWIvJEyGMEgLxOKXLo7j/vq7F4OvtCx4c9yWo7siArWquQ0yMU6bOuZl+
         UW2RgIGa9mXwbvUaCPVIxBar7cYmkVieNHHjoajoKna6zv8oB2K0Dp+AlppEJ+dUJn
         aQARnlphvMsWvDO0BDcWGusbraymGwW4gflM7lfQgwmVTuUN/+btzhxtmrm+bHSYcR
         w/fmCs7oXsY6GfbS9gZkdVqcOmj/xXJyl6Sfn8Y9I2zWV716rmdILi28tj+g16h1da
         2Pal+mXENditg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Wyes Karny <wyes.karny@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bp@alien8.de, Wyes Karny <wyes.karny@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
Subject: Re: [RESEND] [PATCH] Documentation: KVM: Update AMD memory
 encryption link
In-Reply-To: <20230125175948.21100-1-wyes.karny@amd.com>
References: <20230103143931.120939-1-wyes.karny@amd.com>
 <20230125175948.21100-1-wyes.karny@amd.com>
Date:   Thu, 02 Feb 2023 11:33:13 -0700
Message-ID: <87sffnvrx2.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wyes Karny <wyes.karny@amd.com> writes:

> Update AMD memory encryption white-paper document link.
> Previous link is not available. Update new available link.
>
> Signed-off-by: Wyes Karny <wyes.karny@amd.com>
> Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
> ---
>  Documentation/virt/kvm/x86/amd-memory-encryption.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 935aaeb97fe6..487b6328b3e7 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -440,7 +440,7 @@ References
>  
>  See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
>  
> -.. [white-paper] http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
> +.. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
>  .. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
>  .. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
>  .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
> -- 

Applied, thanks.

jon
