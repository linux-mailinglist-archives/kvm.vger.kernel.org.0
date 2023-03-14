Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2186B9D1D
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 18:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjCNRdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 13:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCNRdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 13:33:16 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E18199D53;
        Tue, 14 Mar 2023 10:33:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 3F8F244A;
        Tue, 14 Mar 2023 17:33:03 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3F8F244A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1678815183; bh=eNjPkSLqgCL/qT+w+ujskEEPDJlrV8PfYXaXaO4W+S0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=GkoxPDGhTmniXVBICCYP87PW4h0XGF/yhHmBIGNMvuvS+SmtP1OaTzuzcPjurOwMu
         qitC7nHZLvBbqCzxIlFXlFTr/97HdzeHvfWztcPyXvgowHAdmj/41KLKbLx9naGMBk
         WVCCURiTGpggOSz/xbqgzabgoQSMTjbrGX1/WaPUc8w1tpWFuLfK3JFqaHuZxQZ4j9
         d9JlAAKNyilZuaAnd8e3qpSjb4LV/Ul1mKMGOQcSxnn8SsKKDjyj/lbu44+JVwnlwB
         N8UqZH0Ij9VlNYbR3/+uYdf0FVwecpL0mkAsaTewTTY6vdYHMYMmp0zp87MsQZtpNC
         IZCkbvbv71dvA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jiri Pirko <jiri@resnulli.us>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     alex.williamson@redhat.com
Subject: Re: [patch] docs: vfio: fix header path
In-Reply-To: <20230310095857.985814-1-jiri@resnulli.us>
References: <20230310095857.985814-1-jiri@resnulli.us>
Date:   Tue, 14 Mar 2023 11:33:02 -0600
Message-ID: <878rfztf01.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jiri Pirko <jiri@resnulli.us> writes:

> From: Jiri Pirko <jiri@nvidia.com>
>
> The text points to a different header file, fix by changing
> the path to "uapi".
>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  Documentation/driver-api/vfio.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index 50b690f7f663..68abc089d6dd 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -242,7 +242,7 @@ group and can access them as follows::
>  VFIO User API
>  -------------------------------------------------------------------------------
>  
> -Please see include/linux/vfio.h for complete API documentation.
> +Please see include/uapi/linux/vfio.h for complete API documentation.

Applied, thanks.

jon
