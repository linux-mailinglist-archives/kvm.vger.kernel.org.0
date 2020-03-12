Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24E8183206
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 14:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgCLNva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 09:51:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41229 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727270AbgCLNva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 09:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584021088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2nAfdnCM9aEuiGPmfbZ3pIUNPPugXK/vVGLzpCG2PUc=;
        b=bWxJQFGxTiw/hB3QWCW8EgpPz/4ojr71DKfZ6cdzK0taoW0mVVv3nobUCZ9TGhvp3mdEnx
        Vr86dk3nmrFc9PEnINSs0pSG7232zPXCSNh3lR/rPJoe9uSeKqn6MIN86vwC+qQm5JnSHv
        fs8uAaRIdYItKqlFOUCABIyxnJTN9To=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-FSYLvuUPNXuRIxI3D1YKBA-1; Thu, 12 Mar 2020 09:51:26 -0400
X-MC-Unique: FSYLvuUPNXuRIxI3D1YKBA-1
Received: by mail-wm1-f71.google.com with SMTP id f9so316405wme.7
        for <kvm@vger.kernel.org>; Thu, 12 Mar 2020 06:51:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2nAfdnCM9aEuiGPmfbZ3pIUNPPugXK/vVGLzpCG2PUc=;
        b=nCYMzm7zzhskEXFpSL+OmVWjV2Lvj/xmxFPTRu1R7m4KneRgNXtKbNzatHquG5JODb
         L8hxy/dywxYgU6FdjurZV7aJeCo5mzlpffWTsPETEk0vGxfzEZsMT0qdQy1U8H6T/Y8D
         /D64z5VZeXqOwtefw7Oi3tf1xYs080ZKfTS232EBzvTehrJCu4ICk5qZ5yeipkKR+12r
         fpQDv6ngOwneld2JaIsTjMZCn69D+VYCUBbKvRP3Mp6AKW0itktwFYNVPNxz1VgnvSI8
         JmL6g2FO23pJumWJDQ8ZDWa0B1EMI7VtCVoJMQfDzy/SdxkZaDAihTXFGntCMBMDNLIu
         mKXA==
X-Gm-Message-State: ANhLgQ0sA7BJq/plTZQdZ+uIe17ZxkDMkNZz1kvtRz01bX4Mg1ipaRjj
        n/C/qLvV6hUFCOqTsPipZxPEeYOCr01WeggKsPyqwtLPFXuhfd9i4U5A8yxLzA2IArka1OQ8V+J
        ZkR0ZhJspx6wt
X-Received: by 2002:adf:ea42:: with SMTP id j2mr385413wrn.3.1584021084875;
        Thu, 12 Mar 2020 06:51:24 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtGpDPgE7pICtrNjLgGDlOHy9QvQAE7dJiUg+NXqqUyEmgbX2S2plfpUcE27zOfBojnrAgRow==
X-Received: by 2002:adf:ea42:: with SMTP id j2mr385401wrn.3.1584021084647;
        Thu, 12 Mar 2020 06:51:24 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e1sm64177153wrx.90.2020.03.12.06.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 06:51:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Michael Kelley <mikelley@microsoft.com>,
        Jon Doron <arilou@gmail.com>, Wei Liu <wei.liu@kernel.org>
Cc:     "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv\@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
In-Reply-To: <MW2PR2101MB10522800EB048383C227F556D7FF0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200309182017.3559534-1-arilou@gmail.com> <20200309182017.3559534-3-arilou@gmail.com> <DM5PR2101MB104761F98A44ACB77DA5B414D7FE0@DM5PR2101MB1047.namprd21.prod.outlook.com> <20200310032453.GC3755153@jondnuc> <MW2PR2101MB10522800EB048383C227F556D7FF0@MW2PR2101MB1052.namprd21.prod.outlook.com>
Date:   Thu, 12 Mar 2020 14:51:23 +0100
Message-ID: <87d09hr89w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael Kelley <mikelley@microsoft.com> writes:

> I'm flexible, and trying to not be a pain-in-the-neck. :-)  What would
> the KVM guys think about putting the definitions in a KVM specific
> #include file, and clearly marking them as deprecated, mostly
> undocumented, and used only to support debugging old Windows
> versions?

I *think* we should do the following: defines which *are* present in
TLFS doc (e.g. HV_FEATURE_DEBUG_MSRS_AVAILABLE,
HV_STATUS_OPERATION_DENIED, ...) go to asm/hyperv-tlfs.h, the rest
(syndbg) stuff goes to kvm-specific include (I'd suggest we just use
hyperv.h we already have).

What do you think?

-- 
Vitaly

