Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD26C478DF6
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 15:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237339AbhLQOk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 09:40:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237281AbhLQOk6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 09:40:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639752057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/yoWJglPXPAZw0bxQGxzTmnTF1ai7Cyb2lA49+zOQaA=;
        b=Kbvin4prC3uNSwcVxZJMcwSpi9gn8nOGIFby/7whGAk4SaDMzRVj685pyztsFC36Santke
        72nocJTQsAU2vqwSLxv+lwHPUUhiUbNUJlR6vCxaNB779rvSVqIL2P9myXqP5fBo5Dgy8Q
        BcR6pxfwcAXTYgkly85g7z1F+x1emqA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-Snd99FrmOVuTOXBbtFVKYw-1; Fri, 17 Dec 2021 09:40:56 -0500
X-MC-Unique: Snd99FrmOVuTOXBbtFVKYw-1
Received: by mail-wm1-f72.google.com with SMTP id o18-20020a05600c511200b00332fa17a02eso1136801wms.5
        for <kvm@vger.kernel.org>; Fri, 17 Dec 2021 06:40:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/yoWJglPXPAZw0bxQGxzTmnTF1ai7Cyb2lA49+zOQaA=;
        b=gp6BoBjUKPgHKUn2ABi/ADwdFYtUMTBcILJEEItQCVMvpfhpoy9B+hnOYJqRO9lXW2
         xJDH/TJfQVt/KdCraRAIxFfeUN3slZfmBRdKitePcCqEMFwgP3Oe1NgFN9amLEZsW9Oe
         b5B/8LLZtCJyFD3P02IDhC/bY9KRVGQ8EQ9ywA9jE2q2PkA2wxAfiNqdiYbRkd2RdRyS
         ZlY2fm9DcsyuAp3LkTaHD8AVYtJiLJyoQpVEX+VMutEG22jS6DMmWWFu++E4hGD2zYvk
         +Tpv2vbFkmM9ysW2rbyq17r8l1u1YZvigen3OFdmmXALvrtj93FBlE5zS9Kq2SOMgoTR
         BY7Q==
X-Gm-Message-State: AOAM531soKhA8kwR8x+kv6/Imaa25PSXBKZu4yeKSfCxZ0A+ZcghNfVl
        d1Ak9h5G+LZ67FwnTy+3Vs9uh9kcaD9P50LyGAGPVlcA3tr9F851g21KWJQhPth997Y4RPMzy1u
        TiS7ekxTKo+eF
X-Received: by 2002:a1c:e915:: with SMTP id q21mr3099373wmc.94.1639752055545;
        Fri, 17 Dec 2021 06:40:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzcbPf9fupPFiQTxl/6Lq5J6o57nKgktC42aQsYNIOLu2CqrhXXCb//5f7F/Lc1vxEHhsPDEA==
X-Received: by 2002:a1c:e915:: with SMTP id q21mr3099360wmc.94.1639752055373;
        Fri, 17 Dec 2021 06:40:55 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id j17sm10249998wmq.41.2021.12.17.06.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 06:40:54 -0800 (PST)
Message-ID: <785732e0-733b-fccd-0b3d-0a597f2f68bf@redhat.com>
Date:   Fri, 17 Dec 2021 15:40:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Test PMU virtualization on
 emulated instructions
Content-Language: en-US
To:     Ma Xinjian <xinjianx.ma@intel.com>, jmattson@google.com
Cc:     ehankland@google.com, kvm@vger.kernel.org,
        Philip Li <philip.li@intel.com>
References: <a2cc8bd6-df74-95a7-f3a2-6ff6407a5543@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <a2cc8bd6-df74-95a7-f3a2-6ff6407a5543@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 10:47, Ma Xinjian wrote:
> Hi, Jim
> 
> I am from Intel LKP team, we noticed that pmu_emulation was new added 
> recently by you.
> 
> We tested it and finished with 2 unexpected failures

The patch for this is not yet in kvm.git, since there were some 
discussions on the list.  It will be fixed before the merge window.

Paolo

