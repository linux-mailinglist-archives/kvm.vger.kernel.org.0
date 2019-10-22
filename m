Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF44FE028C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 13:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731904AbfJVLMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 07:12:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbfJVLMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 07:12:14 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC32D85363
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 11:12:13 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id c188so5714391wmd.9
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 04:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E2ZDL5MWE9Y90XTWLGswK0j9jGkUeLSj3bLCyP33D0Q=;
        b=LHlxDopfZG8pXe0GW5w77l5EzB1LUkdSLpkIjmKXxM/5j7B5rqsEOHZkVg1bXdgUWn
         XUr/kkdlE2EWYmjUc7wNXxozkqZp+ufGdLyYW/tPBSz7XwU34Aw5XbVtPApk/4sgElsc
         fQ/J6O+QbpeRRNC6VJcMIrAJ6IjRBqWRDCAhIt29Fm5AG70uGY397mmi/qgYBeE8cI/C
         Adi/ggZ18QpM/7tVJGdKJ+PTJ/tnUcSZt03u6sFIDLc4/LoFhrC44HQh9U0TQ4/51Gti
         uqybj2Vm0xM4s2hsrOKcTjHctEWSVuNIexVYfu/yKFBZ+kfYCmtRsi25yepRd7pejyDo
         apaQ==
X-Gm-Message-State: APjAAAUvr6L+ggfx5EHGI4r47OnJ0tmsJ4sfLi3AmaDm3M29Rt6xPL8A
        BqskpbAFCfhQEX0NdreBjbIYF4SUEBZ9Eeoa2AS4KQcyzZvxKTtGs4Ky3dvJtR3mIpY26imeZR4
        jsfA1X4Y71l3l
X-Received: by 2002:a5d:4a82:: with SMTP id o2mr2963063wrq.186.1571742732594;
        Tue, 22 Oct 2019 04:12:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzQSbg8nAWiZug0SQHMFaSialsyHY/264PzMng3CXcdBC7yG28gelCmJEgWfPnOeawwuhJb2w==
X-Received: by 2002:a5d:4a82:: with SMTP id o2mr2963038wrq.186.1571742732282;
        Tue, 22 Oct 2019 04:12:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id g10sm3434511wrr.28.2019.10.22.04.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 04:12:11 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-fixes-5.4-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
References: <20191021041941.GA17498@oak.ozlabs.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <03cfcf50-7802-56f2-0915-0d890f5d8e75@redhat.com>
Date:   Tue, 22 Oct 2019 13:12:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191021041941.GA17498@oak.ozlabs.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/19 06:19, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.4-1

Pulled, thanks.

Paolo
