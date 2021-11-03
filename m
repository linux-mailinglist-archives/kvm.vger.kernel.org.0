Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F52443D5E
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhKCGn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:43:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231925AbhKCGn5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 02:43:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635921681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ic7/Tv8dzgxGzExYMNDYxIT6r0CNDDhkoEiObvfIC2Q=;
        b=bUQ38015/ESqg62pYX1mKmFIqXP6RRAgbBUip92zZV27zCdotYNeKxe1cFSIu2m9p565Zf
        9859F7wseZdUOQU1l4aNLxdHFBj+NxSzc+Vm/x/eF+gS/cYOHmn19PNJlexII5yyVFjYG8
        4O2TeoIgjKJgX4EpufsufI5jw4BUXPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-zL_Ra5R7M9-kXDtHSiRHnQ-1; Wed, 03 Nov 2021 02:41:18 -0400
X-MC-Unique: zL_Ra5R7M9-kXDtHSiRHnQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E43918A0744;
        Wed,  3 Nov 2021 06:41:16 +0000 (UTC)
Received: from [10.39.192.84] (unknown [10.39.192.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C67F5D9D5;
        Wed,  3 Nov 2021 06:41:07 +0000 (UTC)
Message-ID: <ac937fd6-9db1-6db9-0a30-a3c7e4a16f0f@redhat.com>
Date:   Wed, 3 Nov 2021 07:41:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 3/4] docs: (further further) remove non-reference uses
 of single backticks
Content-Language: en-US
To:     John Snow <jsnow@redhat.com>, qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org,
        Bandan Das <bsd@redhat.com>
References: <20211102184400.1168508-1-jsnow@redhat.com>
 <20211102184400.1168508-4-jsnow@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211102184400.1168508-4-jsnow@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/11/2021 19.43, John Snow wrote:
> Signed-off-by: John Snow <jsnow@redhat.com>
> ---
>   docs/devel/build-system.rst | 21 +++++++++++----------
>   1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/docs/devel/build-system.rst b/docs/devel/build-system.rst
> index 7f106d2f1c..48e56d7ea9 100644
> --- a/docs/devel/build-system.rst
> +++ b/docs/devel/build-system.rst
> @@ -47,16 +47,17 @@ command line options for which a same-named Meson option exists;
>   dashes in the command line are replaced with underscores.
>   
>   Many checks on the compilation environment are still found in configure
> -rather than `meson.build`, but new checks should be added directly to
> -`meson.build`.
> +rather than ``meson.build``, but new checks should be added directly to
> +``meson.build``.
>   
>   Patches are also welcome to move existing checks from the configure
> -phase to `meson.build`.  When doing so, ensure that `meson.build` does
> -not use anymore the keys that you have removed from `config-host.mak`.
> -Typically these will be replaced in `meson.build` by boolean variables,
> -``get_option('optname')`` invocations, or `dep.found()` expressions.
> -In general, the remaining checks have little or no interdependencies,
> -so they can be moved one by one.
> +phase to ``meson.build``.  When doing so, ensure that ``meson.build``
> +does not use anymore the keys that you have removed from
> +``config-host.mak``.  Typically these will be replaced in
> +``meson.build`` by boolean variables, ``get_option('optname')``
> +invocations, or ``dep.found()`` expressions.  In general, the remaining
> +checks have little or no interdependencies, so they can be moved one by
> +one.
>   
>   Helper functions
>   ----------------
> @@ -298,7 +299,7 @@ comprises the following tasks:
>   
>    - Add code to perform the actual feature check.
>   
> - - Add code to include the feature status in `config-host.h`
> + - Add code to include the feature status in ``config-host.h``
>   
>    - Add code to print out the feature status in the configure summary
>      upon completion.
> @@ -334,7 +335,7 @@ The other supporting code is generally simple::
>   
>   For the configure script to parse the new option, the
>   ``scripts/meson-buildoptions.sh`` file must be up-to-date; ``make
> -update-buildoptions`` (or just `make`) will take care of updating it.
> +update-buildoptions`` (or just ``make``) will take care of updating it.
>   
>   
>   Support scripts
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

