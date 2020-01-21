Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1038143966
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 10:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAUJWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 04:22:31 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53288 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725789AbgAUJWb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 04:22:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579598550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NBCUxJYiJBtyWIOfiAuufr0f9f8RpfoqY2xplbMxB2w=;
        b=OHxhdX/hJWw7DltIUa4Vsq9REiaGZcskjs9tHnqhniZKvLY5hutIj8HpOYfJecJTDEXyIU
        pSCkXWksk3xnzaSse8BBRymR9sR30qEuUa5vpR25Cns8wA/i09f8/pWfzDk2pnSwnJ4ONL
        wSWKrbDA+E3YehBe+T+m//q2tdpkkfI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-_xzuz3p_MgKAmE_subS5Kg-1; Tue, 21 Jan 2020 04:22:25 -0500
X-MC-Unique: _xzuz3p_MgKAmE_subS5Kg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EEF7800D4C
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 09:22:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 921B210013A7;
        Tue, 21 Jan 2020 09:22:21 +0000 (UTC)
Date:   Tue, 21 Jan 2020 10:22:18 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Wainer dos Santos Moschetta <wainersm@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests v2 2/2] README: Add intro about the
 configuration file
Message-ID: <20200121092218.ftl2jmxdnbvnggqn@kamzik.brq.redhat.com>
References: <20200120194310.3942-1-wainersm@redhat.com>
 <20200120194310.3942-3-wainersm@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120194310.3942-3-wainersm@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 20, 2020 at 04:43:10PM -0300, Wainer dos Santos Moschetta wrote:
> The 'Guarding unsafe tests' section mention the unittests.cfg
> file which was never introduced before. In this change
> it was added a section with a few words about the tests
> configuration file (unittests.cfg).
> 
> Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> ---
>  README.md | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/README.md b/README.md
> index 367c92a..763759e 100644
> --- a/README.md
> +++ b/README.md
> @@ -52,6 +52,17 @@ ACCEL=name environment variable:
>  
>      ACCEL=kvm ./x86-run ./x86/msr.flat
>  
> +# Tests configuration file
> +
> +The test case may need specific runtime configurations, for

s/The test case/Test cases/

> +example, extra QEMU parameters and time to execute limited, the

s,and time to execute limited,and/or timeouts,

> +runner script reads those information from a configuration file found

s/those/that/

> +at ./ARCH/unittests.cfg.
> +
> +The configuration file also contain the groups (if any) each test belong

s/contain/contains/
s/belong/belongs/

> +to. So that a given group can be executed by specifying its name in the

s/So that a/A/
s/can/may/

> +runner's -g option.
> +
>  # Unit test inputs
>  
>  Unit tests use QEMU's '-append args...' parameter for command line
> -- 
> 2.23.0
> 

Thanks,
drew

