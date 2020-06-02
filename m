Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68901EB31C
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 03:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgFBBoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 21:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgFBBoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 21:44:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1FBC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 18:44:54 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 5so675604pjd.0
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 18:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R+wtA4TQuVAjoHFrtNuxPYnux9aq5YlheMtq49QWXJk=;
        b=Cdn1gJTGL+eXIasgRJVSvqJ5yFZoFpO2kXnl4VB6YbHhYkp3IUjxQ3IoP7FBG/kI86
         e3nfyNDkU3oiuTnarD26uFWmCIh6mF9s9nPytXygGtx47ovpH7sK+2zH3EPZbc4wmPgW
         ePOSo7GSG3rmnRvMzlU1PHvw86n0mX2gkmtkjFhfOH9WAYaQaZrleNKHy4GLZSTfwyFi
         YPNU/2KQ7pI8YpO5GvDoN18cVyTmvB7n2ICL2cp/+R7IlZZBsB6UadkUD9BIys7zS8MT
         GLUQv/62s5bZ/E7xWApYO4WO6ZiMLV/Y+Soh5bxliSTe8IdRKeB+XOpSUuenhk39u4hB
         wsbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R+wtA4TQuVAjoHFrtNuxPYnux9aq5YlheMtq49QWXJk=;
        b=H2qE5DJA1myQWx88z8FoI4jGho0/8SUjjwMj32Asj/qK7ZyBVYMW5IqFtnhonH2UYH
         e4Wfgr3b0RIGpEe2sPok06ieS9XYdgatvGcQj8oxbDJuuyuT/gKQXvLCREV0r9Jube1E
         bjFlX7wCBrENY1ts/aUcMxNg/Q35MbAIYIxRCtIc+gxCQ3doUvh+Kxxyu5zvNbbg5VXT
         J7guZmuBJmfN8ujWB5bpbpIMMmpT9JnfMQtpFBnfyYxczjDpO3rddL+kQyzKH1nfDSAk
         cIUoOJfsB3GEDgod25RS8rW924mrJltreL7aNSJdZ33/I0aQ+MLAWQayYi9A7CTqg5CE
         j8Iw==
X-Gm-Message-State: AOAM533gvA5KoRtwasqR4UQWG+y3mgTCI9g+UVdi5ZClF6b3DEWOaooH
        FojcVY3amerEMy4FdnlAMvBzzw==
X-Google-Smtp-Source: ABdhPJyztznJyQgnMCh6JQJ0vNQfmraNrTA5vuQLGtKFVRHbXlnB2v8XoRNaGDGK/bycvkMFWglT9A==
X-Received: by 2002:a17:90b:400e:: with SMTP id ie14mr2480443pjb.44.1591062293638;
        Mon, 01 Jun 2020 18:44:53 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id b1sm634868pjc.33.2020.06.01.18.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 18:44:52 -0700 (PDT)
Subject: Re: [RFC v2 10/18] guest memory protection: Add guest memory
 protection interface
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-11-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <75221e39-837e-7cd0-6ed8-42610b539370@linaro.org>
Date:   Mon, 1 Jun 2020 18:44:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-11-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> @@ -0,0 +1,29 @@
> +#/*

Two extraneous # at the beginning of the new files.


r~
