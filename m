Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A131ACCAA
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 18:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgDPQDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 12:03:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37984 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895292AbgDPQDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 12:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587053014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+KzySCLznsUiKaMg7tKSU0vPU/bYkMXagzGokChYVbc=;
        b=UWK4z+vVinrm6gYbJrDkO8ttObNW1aHPdj7deeGhsNgrx5PEI1PhxTpYSPPEKC39UFiA+t
        wfZ3Mi14NvPx2luEAvP8L1O9ioKKuosFHZts143TCytH+8WrwCbfuSqhoFeAWxYRdtf/P4
        hIU3MbBRmXEFzcDer54Rm9920xpYI08=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-yn7sr3EcNEGorlePZrcOcQ-1; Thu, 16 Apr 2020 12:03:32 -0400
X-MC-Unique: yn7sr3EcNEGorlePZrcOcQ-1
Received: by mail-qv1-f72.google.com with SMTP id p6so3726903qvo.18
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 09:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+KzySCLznsUiKaMg7tKSU0vPU/bYkMXagzGokChYVbc=;
        b=s3WBiLlC2Ix/8SYHBaOiIhhoqwtH9XBDb+GoqtP2nsst1FixB5XKyC8KeGRd208Kb5
         lMMoZBUNWwkikyYrVNdrjzS3rNxEAfIclRGt7FL/IrN+iAxoORkfssH2imxbxGrHpQpE
         qRwifVIfQuxt/NaKAJdY+ZdlnXc3Agbi3uwjrBhA6/hezy4Hwb1eWMvPCnaIv9hLMnnO
         BHo+TgsS53RLGp+sfBKh4vWOiSX25dcFWrsNiZtBtse+WHidx0l1193d+XZlD0bIhco+
         MPjb05ZFMq9iXmm21jKP9v1NiosD5ynjuUOCz3tpr+CaAVoyTRgsADffS0j6JSMoEI8t
         Xykg==
X-Gm-Message-State: AGi0PuZOoPrrrv0O5Q6cM4x+WQqRW4otNNY1Dlw9e8FLd6dy1tyPE80b
        P78KV4gd8AFpGMD18BYJIMrU+u9DW0ck8jZGmRBp2cGCau39HRbukyEJkhSvKqwCLW8CxJPX9sO
        pEE9G+kLBan0q
X-Received: by 2002:a05:6214:1705:: with SMTP id db5mr10678718qvb.74.1587053011932;
        Thu, 16 Apr 2020 09:03:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypKQopMPgf13GnimCkR4RHu+62g6/IrGnLDV3YVJDrO3HO8uuQDh2hG3cl9YrOkrkpVRQY5y3w==
X-Received: by 2002:a05:6214:1705:: with SMTP id db5mr10678689qvb.74.1587053011668;
        Thu, 16 Apr 2020 09:03:31 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 28sm4886245qkp.10.2020.04.16.09.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 09:03:30 -0700 (PDT)
Date:   Thu, 16 Apr 2020 12:03:28 -0400
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/5] KVM: X86: Force ASYNC_PF_PER_VCPU to be power of two
Message-ID: <20200416160328.GA266621@xz-x1>
References: <20200416155322.266709-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200416155322.266709-1-peterx@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry, please ignore this one.

-- 
Peter Xu

