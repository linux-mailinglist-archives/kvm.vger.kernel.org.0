Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C17717074
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 00:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbjE3WMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 18:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbjE3WL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 18:11:59 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF2311C;
        Tue, 30 May 2023 15:11:52 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d2da69fdfso5795133b3a.0;
        Tue, 30 May 2023 15:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685484712; x=1688076712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EvBZHkvL1aURqZXFZC4d4YP3G3jQMOUC4RE4X8Qh5Qw=;
        b=CoAnW59diY9DHipcXzl92JrThq8EFUsEcad9Jf6i91mXumHaIHaIQqeciTob+tSrNj
         a+SJi6Zw0+DjqiYYYqQWTsUc/4yrU3ZmTUpqlOfzeU0eEmXl188pHRALWuMIAk64Wdii
         CW9Y1frtGlSDYVpmP3bclZb34bsp22eyl2OJ90qrOGyU+/arg+WzEZEEHO4sIjLEnuwG
         kauXuIpyHFQicElsset5CdKBa/Q6CGbiBWzIdgCEhYXM/M3aT/fAdj3ftbYSdp8BI6Mf
         EaiAq2NWumpJvtI5cd89GKYWjDc8Rb9Mafl/DEIK38UsB27K8nLMZOHoTkXTt+UUbCOX
         G5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685484712; x=1688076712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EvBZHkvL1aURqZXFZC4d4YP3G3jQMOUC4RE4X8Qh5Qw=;
        b=AemTSZdbG8s0UbZf1qK8m3jAI2iMM6Gl50pr7FERIajPHO8tDcRtIAk4iKt/Gkqsc+
         w0ljQjbpjGy3zUsoCX20lJffDH4Ytc61FYpXqonAJDf/h4+ZozICjsNwAWEHLqrO3XoM
         1HR0gJULFClIE/yjgVOjHLa3jd70N70b/BJfSDv6fKq9VONTmI/dx0zyVCokDZGlH9MW
         +R8biDBRMuOk9jsBWESNV3/RWK5Tw+zAnmkdJhO1OxbEnVsOOSEMOPqw6dWRUfKx1k3Y
         e3dvtauDZHfVvZ5Lvw2tjV4drZEP2QFF4UcttVYUGpakVc5lw53l1AJCmysgnaG14qDs
         PPng==
X-Gm-Message-State: AC+VfDwbsqWqBt52NABf0uOBB+CwtUk1CZjT782EdvW5TabAjG9rPMBA
        uJuKdwijrtYHR2Me4PslNyI=
X-Google-Smtp-Source: ACHHUZ6Oy6C4x2AaSCz9oTPGdqSW7vv7F9On3t53axl555lthLjr6vcSYgbWnB4eOlMR5W9OtcGbdQ==
X-Received: by 2002:a05:6a00:2488:b0:643:980:65b with SMTP id c8-20020a056a00248800b006430980065bmr4195560pfv.2.1685484711725;
        Tue, 30 May 2023 15:11:51 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id n14-20020aa7904e000000b00625037cf695sm2092126pfo.86.2023.05.30.15.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 15:11:51 -0700 (PDT)
Date:   Tue, 30 May 2023 15:11:49 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        "Chen, Bo2" <chen.bo@intel.com>
Subject: Re: [PATCH v14 000/113] KVM TDX basic feature support
Message-ID: <20230530221149.GE1234772@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <DS0PR11MB6373D94AE8420F45798E7D40DC4B9@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373D94AE8420F45798E7D40DC4B9@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023 at 07:34:44AM +0000,
"Wang, Wei W" <wei.w.wang@intel.com> wrote:

> On Monday, May 29, 2023 12:19 PM, isaku.yamahata@intel.com wrote:
> > The tree can be found at https://github.com/intel/tdx/tree/kvm-upstream
> > The corresponding qemu branch is found at
> > https://github.com/yamahata/qemu/tree/tdx/qemu-upm
> > How to run/test: It's describe at https://github.com/intel/tdx/wiki/TDX-KVM
> 
> Seems the above wiki lacks some update, e.g. tdx needs to be enabled explicitly
> when loading kvm_intel, example command line (e.g. private=true for
> memoy-backend) to launch TD with gmem.

Thanks for pointing it out. I've updated those items.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
