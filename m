Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E4B6D881B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 22:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbjDEUV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 16:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjDEUVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 16:21:55 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C040F19BF
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 13:21:53 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id i22so26437239uat.8
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 13:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680726113;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RjmMdJgCPc7w+c38QfgjWrjQ59qEslQQ2y8WjQqr6nw=;
        b=pxEPbdTPZQTNyxQddLcWfsccN+xfyBWlySVjtD0PolfUN/biUE3xQOXBGLYekFxvyr
         4aPIp3/Yf50gf3WfORTXnCqANYRfj8eMJBn45/i/0g1dzC126Wiv4DttBJR1ImJgIiit
         AggfdydF7K0GE+MDiY4E/GSlPYIZMNlQlQkag0zM9rY0EPGVL8xiYpU1uIrBTEALHHLW
         UA2+nSCaQfDJ8b9aTOMwG6Ru109Oe7PwmRCTL65SSiRlFy0trJ7UfpXTiA2IL9PN0Ueg
         akpdH9SZe6tJg0PL7RQtejx7WBrbhmP6d7iC0pBQjHi6oxMYWxZT4JPYPU2PzYyjeyIq
         ISXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726113;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RjmMdJgCPc7w+c38QfgjWrjQ59qEslQQ2y8WjQqr6nw=;
        b=nSAKT3o3kSIGeO8dzqcJjHQ56Lptb3WWT+/GYWBcoI/RpC6ePAnoWVQyVmweWn/uex
         J1ldu/4aH+n8WaRfmmv1+WzkSfVjao+ZpOAzwyqa5bqKM8zVdLbm4aYp82dczS5dCRhK
         gS8MzZWitugAEPmkRVeR8ySTFJe8d8yyqoN9RRhrLZf0C8z0uTWMvP0mwRE8DTLcTnSw
         k3SK0LC4SEyuGI6u0IXTNaIN/Fsc+R7d7KbocaxBqXUXflJW7MY4LKeLa6rQ6hcPTKEQ
         E3ZMNEnUYgNFr34Ho7IEUfe1LDja9vpeG4XVzXrJqHUXjgTlXAVccS9t9rgjhFUJVA1a
         VtzA==
X-Gm-Message-State: AAQBX9fhBLgG6IYIWko0Q9AboQ3sjFrvM1Nbl1AdWM4vEximWrm45m4u
        +nBpDFrbW1VyG5NfLSHQhJ+Yn0Uk5hjQll668SMsRw==
X-Google-Smtp-Source: AKy350aygi7Qm9IYIzK0BIl8sJVJmJprVNEfFsM8RdVD31quTgZYXxbQg9BHPwF/roOnRYs5gEWkoNFHUliLtNWBIwM=
X-Received: by 2002:a05:6122:793:b0:3e9:e7cc:7e8b with SMTP id
 k19-20020a056122079300b003e9e7cc7e8bmr4349785vkr.4.1680726112900; Wed, 05 Apr
 2023 13:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com> <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
 <ZBnLaidtZEM20jMp@google.com> <CAF7b7mof8HkcaSthEO8Wu9kf8ZHjE9c1TDzQGAYDYv7FN9+k9w@mail.gmail.com>
 <ZBoIzo8FGxSyUJ2I@google.com> <CAF7b7moV9=w4zJhSD2XZrnZTQAP3QeO1rvyT0dMWDhYj0PDcEA@mail.gmail.com>
 <ZCx74RGh1/nnix6U@google.com> <CAF7b7mpbeK24ECkL4RWG3S6piYQQTEqLFMKYTFz9g4tcjVdZVw@mail.gmail.com>
 <ZCyfhj729wGXi7B/@google.com>
In-Reply-To: <ZCyfhj729wGXi7B/@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 5 Apr 2023 13:21:16 -0700
Message-ID: <CAF7b7mr2zrXsuGT-KjC+Lb10aZURrEbrW3Bu8-FonR60EKkpRw@mail.gmail.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ok. I'm still concerned about the implications of the "annotate
everywhere" approach, but I spoke with James and he shares your
opinion on the severity of the potential issues. I'll put the patches
together and send up a proper v3.
