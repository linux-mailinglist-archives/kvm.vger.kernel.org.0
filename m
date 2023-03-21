Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C981E6C3912
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 19:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjCUSVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 14:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCUSVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 14:21:47 -0400
Received: from out-16.mta0.migadu.com (out-16.mta0.migadu.com [IPv6:2001:41d0:1004:224b::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D96172F
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 11:21:45 -0700 (PDT)
Date:   Tue, 21 Mar 2023 19:21:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679422904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0XP2feTT2Z2INPHdm7OkUTkCkmq3/0dKtwzIAK4qP4M=;
        b=mu26yxoUUDKKXI+owB4m1511CeXntWGz2MRL9iEnhX14pxDt04Z298MGOpeoH1QTTtN1V4
        7kkyzKSL15Xa+wt7bvLE1YJ1GccHWNE5EZbZMAZZwy9uG3FGgZw5IVvVizwCibo7qiOK8v
        foL2ZqVZNsFyz5OCs2WvNCo4k4/4vUk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [PATCH v4 28/30] arm64: Add support for efi in Makefile
Message-ID: <20230321182143.q4pctesnrunnvak3@orel>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-29-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213101759.2577077-29-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023 at 10:17:57AM +0000, Nikos Nikoleris wrote:
...
> --- a/configure
> +++ b/configure
> @@ -208,14 +208,19 @@ else
>      fi
>  fi
>  
> -if [ "$efi" ] && [ "$arch" != "x86_64" ]; then
> +if [ "$efi" ] && [ "$arch" != "x86_64" ] && [ "$arch" != "arm64" ]; then
>      echo "--[enable|disable]-efi is not supported for $arch"
>      usage
>  fi

Need to also update the usage text with

-           --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
+           --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 and arm64 only)

Thanks,
drew
