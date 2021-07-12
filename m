Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E0C3C60B6
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 18:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhGLQkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 12:40:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233756AbhGLQkh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 12:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626107868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DmsrfUJqVuzKIhoeVB1ab8GPQvYJh20rCkMxoqwgccc=;
        b=iLcJaA84nFVoUH12X/mg1M6/IB6BEiXGRP/w/SUBVbTkpxA1Bor1X9vtVmqhoZHD5q7y3g
        DnKzkMIY+aeqW8xkd8KdGpqgJD/NqLLkoseE88HuP12mqCAhv/ZPdCPC9VswQ8nYFCAUI4
        9YbKCKZ36D/zW3dwNOMitmWpJaLc2II=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-KyDQjnB_N12KoXzLV_567A-1; Mon, 12 Jul 2021 12:37:47 -0400
X-MC-Unique: KyDQjnB_N12KoXzLV_567A-1
Received: by mail-il1-f197.google.com with SMTP id b8-20020a92c8480000b0290208fe58bd16so4822068ilq.0
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 09:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DmsrfUJqVuzKIhoeVB1ab8GPQvYJh20rCkMxoqwgccc=;
        b=oEiWa7G8d6V9Lw8gXejUfXXg2CATKzasIvwpeOdvHT13kW+QYOMUX6te6OMzCzERwW
         QHbEw4lB/shbFa1gULMtGNpdRggQM4UGlJYRlu2NkcRIYLAGGyJNqy+6NwVN/uDN39SD
         BtjFqXMgT1RZGZjECkIG1MC2EC90BiPV+hyXlWerTh4WVXkZSlIKUQta82sk4toyphbz
         L7y0E2sv/OtzqiuCzF1dwpcGsNFmjrYP1XmLGgF9bmsajqMC3l12MjBKzf3vNcbIb7Rm
         geeUun8qqEfKFEZCPSulSNg7YmJ43ustgOg7VFk/9gFx3m0OF14NBouAI50w07cPkRty
         TQUg==
X-Gm-Message-State: AOAM532SlrzDZSF+PLt3OuwwoLK4PRu6TkiGEXjG/hiSZFuE0kWl2wOT
        PaK6SnME5au/BnTm25hLHr8S/5yBlufxnJOL20DF8M+gZGB1pHbnl39fMEzLyODFbzk6DE+1RWj
        XwYYy0t3XI58y
X-Received: by 2002:a92:7a12:: with SMTP id v18mr11239782ilc.27.1626107866875;
        Mon, 12 Jul 2021 09:37:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVBVoWaMr/V5Gyw1JMvoSpF+iBmSnxs3Lb0dTzJIaWKLxJccOVfvstXhDuQpUmyCOaoGc3Jw==
X-Received: by 2002:a92:7a12:: with SMTP id v18mr11239751ilc.27.1626107866573;
        Mon, 12 Jul 2021 09:37:46 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id y13sm7797842ioa.51.2021.07.12.09.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 09:37:46 -0700 (PDT)
Date:   Mon, 12 Jul 2021 18:37:44 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 2/5] scripts: Rename run_qemu_status
 -> run_test_status
Message-ID: <20210712163744.5qj3jddg4j6abuq4@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702163122.96110-3-alexandru.elisei@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021 at 05:31:19PM +0100, Alexandru Elisei wrote:
> kvm-unit-tests will get support for running tests automatically under
> kvmtool, rename the function to make it more generic.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/arch-run.bash | 2 +-
>  powerpc/run           | 2 +-
>  s390x/run             | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 5997e384019b..8ceed53ed7f8 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -69,7 +69,7 @@ run_qemu ()
>  	return $ret
>  }
>  
> -run_qemu_status ()
> +run_test_status ()
>  {
>  	local stdout ret
>  
> diff --git a/powerpc/run b/powerpc/run
> index 597ab96ed8a8..312576006504 100755
> --- a/powerpc/run
> +++ b/powerpc/run
> @@ -31,4 +31,4 @@ command="$(migration_cmd) $(timeout_cmd) $command"
>  # to fixup the fixup below by parsing the true exit code from the output.
>  # The second fixup is also a FIXME, because once we add chr-testdev
>  # support for powerpc, we won't need the second fixup.
> -run_qemu_status $command "$@"
> +run_test_status $command "$@"
> diff --git a/s390x/run b/s390x/run
> index c615caa1b772..5a4bb3bda805 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -28,4 +28,4 @@ command+=" -kernel"
>  command="$(timeout_cmd) $command"
>  
>  # We return the exit code via stdout, not via the QEMU return code
> -run_qemu_status $command "$@"
> +run_test_status $command "$@"
> -- 
> 2.32.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

