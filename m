Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0D560ECF7
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 02:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiJ0AWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 20:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiJ0AWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 20:22:13 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDE932AB2
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 17:22:11 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9so5655746pll.7
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 17:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gL9fkvyetCV1Bo4juUosdq663yh2iF/xfOUblLWF8b0=;
        b=X+ikZz4N8iSORkePbs8KKFAw6/SMc/hBT2Lp36JJJ9UwFAzIffLIbQZ89F7LV1p1Es
         Zwqb3/KV5EErGZLwLu6c+d55aFsXqcoXQ7a+03+6PNGJECdsNz5S+m6877qEgGMYqedE
         9WIbZYu2ZX1eM0ljenU9obLoqtcxafobLUhMzly6BMH18guetLEQ6iJWn56UEIilIl6g
         KNt/vS94GXjd2tOjWW20jZbB0j79EOQCAxyu6HsBfRZZPD8YuogjVZT4n73cYJJXKWWg
         PXJ9eQZshqBs2Uh83w+L1EXalXzlZfQFQkBsikDbhHssZFWCg7crwx8gt8YpnJZNPfD1
         pIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gL9fkvyetCV1Bo4juUosdq663yh2iF/xfOUblLWF8b0=;
        b=Cz8zXop4oxrz4I7cUj0thU0Qq/RHcpe4Vn3izZnAg9z+DCt0Hv+pziwTbEWCKgfpPv
         ErZ6MSQCP/caj338J1oo05nZvnS4ELWCDQi3Xs7j4bLpnZmAp+WfOJlaZ2o6jhbFowts
         RRRVxXBbKbcuXD5WtU+a5tkx1aHnNw8U9r6HTx6ZlbrrbI5ThPhWISuoalaRNpIg3/7o
         t7KhZfIuw651orwtm5HFwI5FJbbaikCCBMgX7fq0+jj4CgOdlWaqn+7B/AgZoxGF9EYF
         TyqntFWhuPOJN86ZU27bfZghiqaVjmoVGpPsp0eV2rDZi6Sn31uU17D/uY7CRNqqUVzI
         /Vsg==
X-Gm-Message-State: ACrzQf0obwTnM+BFVaQ50R29vsL+w6XEATrk90+1C2XjpycXI1j6oV/s
        iCw4u2u9cTr52ontBIGlitoNlA==
X-Google-Smtp-Source: AMsMyM6CD/Y7haI/KExpKQwtJ210I7ZMQY9GjXxFShh03utqVHZJ37k1rcflFBfWHz+H6N05MVxMcQ==
X-Received: by 2002:a17:902:e752:b0:186:9efb:71f3 with SMTP id p18-20020a170902e75200b001869efb71f3mr20644688plf.153.1666830130438;
        Wed, 26 Oct 2022 17:22:10 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d8-20020a170902654800b001788ccecbf5sm3472832pln.31.2022.10.26.17.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 17:22:09 -0700 (PDT)
Date:   Thu, 27 Oct 2022 00:22:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, vipinsh@google.com,
        ajones@ventanamicro.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 18/18] KVM: selftests/kvm_create_max_vcpus: check
 KVM_MAX_VCPUS
Message-ID: <Y1nPLpybEYWh+Znu@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-19-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113445.1022147-19-wei.w.wang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022, Wei Wang wrote:
> If the KVM side max vcpu number is larger than the one supported by the
> userspace selftests, adjust the max number.

No, this defeats the purpose of the test.  "create max vCPUs" means "create the
maximum number allowed by KVM", not "create the arbitrary max supported by selftests".
