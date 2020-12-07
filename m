Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AF12D09F6
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 06:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgLGFMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 00:12:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725648AbgLGFMx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 00:12:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607317886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qab4deHbU/VN7oqCq/ddeCw/xxFnxVTtrXJHAdanJ30=;
        b=Wd2KUSwnCLr0XfStrF0+coXglJjXzI4yua/+Gv+o/8GdKmFNkomTSQG8Nqwj0Me2XwAM0M
        YwCJ2w2COGhRJ8jGWgheBtEn1/bi+Xwqxj+difq0eSzhVDmCy86Ncpp31sc93amy2oDZ/q
        nuyZLbMA25pr7OZF5koYPo6hZeEL83c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-v49AIyVENfWDHZqo9wU_CQ-1; Mon, 07 Dec 2020 00:11:24 -0500
X-MC-Unique: v49AIyVENfWDHZqo9wU_CQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CB29800D55;
        Mon,  7 Dec 2020 05:11:22 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9D315D6AB;
        Mon,  7 Dec 2020 05:11:09 +0000 (UTC)
Subject: Re: [PATCH 1/8] gitlab-ci: Replace YAML anchors by extends
 (cross_system_build_job)
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Huacai Chen <chenhc@lemote.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Claudio Fontana <cfontana@suse.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org
References: <20201206185508.3545711-1-philmd@redhat.com>
 <20201206185508.3545711-2-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e5494ad3-a67e-0013-b48f-0fa82d67c397@redhat.com>
Date:   Mon, 7 Dec 2020 06:11:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201206185508.3545711-2-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
> 'extends' is an alternative to using YAML anchors
> and is a little more flexible and readable. See:
> https://docs.gitlab.com/ee/ci/yaml/#extends
> 
> More importantly it allows exploding YAML jobs.
> 
> Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  .gitlab-ci.d/crossbuilds.yml | 40 ++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

