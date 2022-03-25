Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620E24E7867
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 16:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245408AbiCYPx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 11:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376990AbiCYPxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 11:53:20 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BC550E1B;
        Fri, 25 Mar 2022 08:51:46 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id a30so3396567ljq.13;
        Fri, 25 Mar 2022 08:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=p6bJQfqvBfV8ypBWgRO+fxUT6Hho7lDeNEv68zPpbaM=;
        b=mY2XTJHXnHDEubK3XQ1hIpvutXFwerqhwu1HRkwfurvei+YCx36wTpkh4N0qeYwatN
         rElZivtOsR19fbMPh8vUGRUw+imcdfzn7koCggV5XwJZFlajV/dxOp1I8MU3GEC7USFp
         2q9C/SXEVnunPO37MpA6acXygAHucq0ZOBoQ0AHiNrLXM32nSr4w53F6mn4NNMNaa6xz
         gUog+BJMxd7TfTYZQ0/PK7A+50ua9FxCG49jDud0bDADAfSbKIpIBEPKEYbTtMeSpBFL
         7lTM2YkgvpffP0dRnngdC4TYoMOobs29unWbQW2STlOYQjx7dLKPhuE5cX5Bq5jEk3Z4
         BVtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=p6bJQfqvBfV8ypBWgRO+fxUT6Hho7lDeNEv68zPpbaM=;
        b=Rjvogec1vkgbwNnBoR6oNgDk8k3mzGBUyed7+A+ugmV1BD3CaDzUyqOiNws4QA6pMF
         nGLxFgeUr9XdArjgUaGOnAZecAsjF9izH2t6UBftNaTOYNQsOhnxlhVhpRsYhcBfHgfc
         paD+ZFhF2Ys3h5VrCMGF519d9aRC/ubjytdCY9aCmM05WdrObgBk/ZsKIW9zHedvMlkT
         UN/woPovGnm0OD3PxhFErHGOW2b9KR9L48YZN5cXCMR9JUR2zwT9VMDsKVHyxZt/9TTj
         V2fo/linSf9XIZ6jV7h0OHLL8jY/uMvu0qf8ya4hB47W8qR4DrVQJssfv42yfehLdrph
         rF9Q==
X-Gm-Message-State: AOAM5335+Bt0UfWhBr+ozBusAf2+3k2waxvJfBnZ7XORXr2LAbQl7dBy
        l+4kr8fQkOp/c+LDmyxnWRo=
X-Google-Smtp-Source: ABdhPJyaR77ltfm4joCNtoqFq4nh2sdn3hlz/scZ7EVaTILDIBB6/Yd38iO3jRMQDIbMamWyXZX3Sg==
X-Received: by 2002:a2e:6e0d:0:b0:247:fc9c:284e with SMTP id j13-20020a2e6e0d000000b00247fc9c284emr8726856ljc.251.1648223504444;
        Fri, 25 Mar 2022 08:51:44 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.225.225])
        by smtp.gmail.com with ESMTPSA id o7-20020ac24c47000000b0044a15c4e0aesm741758lfk.272.2022.03.25.08.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 08:51:43 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------xd9s8aJo1C2Exy5fYVGAfcXa"
Message-ID: <1a1172db-12f6-1173-b526-89e4da00e96a@gmail.com>
Date:   Fri, 25 Mar 2022 18:51:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [syzbot] general protection fault in kvm_mmu_uninit_tdp_mmu
Content-Language: en-US
To:     syzbot <syzbot+717ed82268812a643b28@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <000000000000a5cb1305db0aaf48@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000a5cb1305db0aaf48@google.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a multi-part message in MIME format.
--------------xd9s8aJo1C2Exy5fYVGAfcXa
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/22 16:10, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f9006d9269ea Add linux-next specific files for 20220321
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=101191bd700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c1619ffa2b0259a1
> dashboard link: https://syzkaller.appspot.com/bug?extid=717ed82268812a643b28
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109e8f5d700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1666180b700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+717ed82268812a643b28@syzkaller.appspotmail.com
> 

The following code is not safe:

arch/x86/kvm/mmu/tdp_mmu.c:

28	kvm->arch.tdp_mmu_zap_wq =
29		alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
30
31	return true;


Looks like kvm_mmu_init_tdp_mmu() error value is just ignored, and then 
all kvm_*_init_vm() functions are void, so the easiest solution is to 
check that tdp_mmu_zap_wq is valid pointer


#syz test: 
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master




With regards,
Pavel Skripkin
--------------xd9s8aJo1C2Exy5fYVGAfcXa
Content-Type: text/plain; charset=UTF-8; name="ph"
Content-Disposition: attachment; filename="ph"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jIGIvYXJjaC94ODYva3Zt
L21tdS90ZHBfbW11LmMKaW5kZXggZTdlNzg3NjI1MWIzLi5iM2U4ZmY3YWM1YjAgMTAwNjQ0
Ci0tLSBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jCisrKyBiL2FyY2gveDg2L2t2bS9t
bXUvdGRwX21tdS5jCkBAIC00OCw4ICs0OCwxMCBAQCB2b2lkIGt2bV9tbXVfdW5pbml0X3Rk
cF9tbXUoc3RydWN0IGt2bSAqa3ZtKQogCWlmICgha3ZtLT5hcmNoLnRkcF9tbXVfZW5hYmxl
ZCkKIAkJcmV0dXJuOwogCi0JZmx1c2hfd29ya3F1ZXVlKGt2bS0+YXJjaC50ZHBfbW11X3ph
cF93cSk7Ci0JZGVzdHJveV93b3JrcXVldWUoa3ZtLT5hcmNoLnRkcF9tbXVfemFwX3dxKTsK
KwlpZiAoa3ZtLT5hcmNoLnRkcF9tbXVfemFwX3dxKSB7CisJCWZsdXNoX3dvcmtxdWV1ZShr
dm0tPmFyY2gudGRwX21tdV96YXBfd3EpOworCQlkZXN0cm95X3dvcmtxdWV1ZShrdm0tPmFy
Y2gudGRwX21tdV96YXBfd3EpOworCX0KIAogCVdBUk5fT04oIWxpc3RfZW1wdHkoJmt2bS0+
YXJjaC50ZHBfbW11X3BhZ2VzKSk7CiAJV0FSTl9PTighbGlzdF9lbXB0eSgma3ZtLT5hcmNo
LnRkcF9tbXVfcm9vdHMpKTsKQEAgLTExOSw5ICsxMjEsMTEgQEAgc3RhdGljIHZvaWQgdGRw
X21tdV96YXBfcm9vdF93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAogc3RhdGlj
IHZvaWQgdGRwX21tdV9zY2hlZHVsZV96YXBfcm9vdChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVj
dCBrdm1fbW11X3BhZ2UgKnJvb3QpCiB7Ci0Jcm9vdC0+dGRwX21tdV9hc3luY19kYXRhID0g
a3ZtOwotCUlOSVRfV09SSygmcm9vdC0+dGRwX21tdV9hc3luY193b3JrLCB0ZHBfbW11X3ph
cF9yb290X3dvcmspOwotCXF1ZXVlX3dvcmsoa3ZtLT5hcmNoLnRkcF9tbXVfemFwX3dxLCAm
cm9vdC0+dGRwX21tdV9hc3luY193b3JrKTsKKwlpZiAoa3ZtLT5hcmNoLnRkcF9tbXVfemFw
X3dxKSB7CisJCXJvb3QtPnRkcF9tbXVfYXN5bmNfZGF0YSA9IGt2bTsKKwkJSU5JVF9XT1JL
KCZyb290LT50ZHBfbW11X2FzeW5jX3dvcmssIHRkcF9tbXVfemFwX3Jvb3Rfd29yayk7CisJ
CXF1ZXVlX3dvcmsoa3ZtLT5hcmNoLnRkcF9tbXVfemFwX3dxLCAmcm9vdC0+dGRwX21tdV9h
c3luY193b3JrKTsKKwl9CiB9CiAKIHN0YXRpYyBpbmxpbmUgYm9vbCBrdm1fdGRwX3Jvb3Rf
bWFya19pbnZhbGlkKHN0cnVjdCBrdm1fbW11X3BhZ2UgKnBhZ2UpCg==

--------------xd9s8aJo1C2Exy5fYVGAfcXa--
