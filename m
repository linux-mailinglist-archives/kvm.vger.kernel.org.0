Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957FF3DEB98
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 13:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbhHCLPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 07:15:38 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:49791 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235329AbhHCLPg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 07:15:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6E0A95807E1;
        Tue,  3 Aug 2021 07:15:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 03 Aug 2021 07:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=+Xs6//bU5l7/gZyXyD347kA1zrr
        OWPhZTHnZnm3AFPw=; b=xezwV5QWQ5ZGQ8GNaFxlGCKcRoFp1UDjPfMWRRhxiUI
        q4L+3dsbMmrlSqy/JYevH44FLh/ew47F+ovgCxihraUmdXdkrA8aLD36GQ/2lJws
        y3YKq8ZC0r3XhgTOEst/fbpPnaXEU9bh/OtVMrLjlKfVpkGpy+9fYvGCKDvQsJhV
        xcEexSzK2QStwTqp/P47QgwLRkbzPMVkjCgr83qpdPUAZKhKm2QD4oOck/ArI9to
        xTHMu1i6T9AvFdS5fU6ShxqV7a4ozudwbMl9paecyC8mA4CRQIK7omki82gHR2T7
        5/DIBT3vBqYUXmzfqJmKdzWPoS6GIvDurDGpkiDSsiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+Xs6//
        bU5l7/gZyXyD347kA1zrrOWPhZTHnZnm3AFPw=; b=QZzenmNBTuOln//tTLWYlL
        QHDMDrgLBqycq6lgPx++g141v04PQZQh76NItk75M5TRwdjBLsut+sQFkZLxmduu
        VCCuD2hGAgvu/LpNqLRDkmqaV9ko2UFzb+k61a3yybnp772GaJryceJWha4xW7yW
        ECRwaPtTX9n4RbqNLLy5aKncySJ3OQGjJ5RrPYm3WsifUcSoF/cbXc9MTDd4lg0P
        ibBF+UfY+/WDqvrKEz6oUFn7AnuVRmw9alEgjBZjo0PaKOhdrp8f/C/FZiduOz53
        7e6wbDxkHzZ4nkNQtB30x2dJvOWJLr0DCYh7fFW9+1bTtCjp4DhMlP8UpnePzlYw
        ==
X-ME-Sender: <xms:TSUJYf0Dtfp6BKHuY8A9S6sSBdL27QH4anKjMxL6KeocrZdGZCgkdg>
    <xme:TSUJYeEc2rt6pcl8vC8WwJkoiSY8egOcCFSsbj0mB0N04iotLIJm7_ePzw9vC-Ebj
    UR0WKQrVmVsww>
X-ME-Received: <xmr:TSUJYf7JnKYEmFESxOOCUChWgPCC1uTw6uCpwFQmKFxyq0cCMzocOWAGBf-_ZlnoziF0V3gSdBWT9I7Y8KO7XTJffpsBAXSG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrieeggdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:TSUJYU2hR43niPDU8t-eI0mv10M2rpYlvWQd7flH0imkputOo2Oriw>
    <xmx:TSUJYSGgqjefDK_rkChIQFmTXLBy30t9ReEOVxxg6KSwlnCXuyrlPg>
    <xmx:TSUJYV9w1ryKD2xDGlBXYg6TcJ5cQIofCKT2Val6TP8SuCp-g2Bc6g>
    <xmx:TSUJYZe0rVaZwOFFpu9D8CjSxvtN9uFs0g0XGbgMwDq-3y-QsFC9JA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Aug 2021 07:15:24 -0400 (EDT)
Date:   Tue, 3 Aug 2021 13:15:19 +0200
From:   Greg KH <greg@kroah.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/7] KVM: Allow to have arch-specific per-vm debugfs
 files
Message-ID: <YQklR580FbVSiVz6@kroah.com>
References: <20210730220455.26054-1-peterx@redhat.com>
 <20210730220455.26054-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730220455.26054-2-peterx@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 06:04:49PM -0400, Peter Xu wrote:
> Allow archs to create arch-specific nodes under kvm->debugfs_dentry directory
> besides the stats fields.  The new interface kvm_arch_create_vm_debugfs() is
> defined but not yet used.  It's called after kvm->debugfs_dentry is created, so
> it can be referenced directly in kvm_arch_create_vm_debugfs().  Arch should
> define their own versions when they want to create extra debugfs nodes.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 20 +++++++++++++++++++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9d6b4ad407b8..a3ec3271c4c8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1067,6 +1067,7 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  int kvm_arch_post_init_vm(struct kvm *kvm);
>  void kvm_arch_pre_destroy_vm(struct kvm *kvm);
> +int kvm_arch_create_vm_debugfs(struct kvm *kvm);
>  
>  #ifndef __KVM_HAVE_ARCH_VM_ALLOC
>  /*
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a96cbe24c688..327f8fae80a5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -915,7 +915,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  	char dir_name[ITOA_MAX_LEN * 2];
>  	struct kvm_stat_data *stat_data;
>  	const struct _kvm_stats_desc *pdesc;
> -	int i;
> +	int i, ret;
>  	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
>  				      kvm_vcpu_stats_header.num_desc;
>  
> @@ -960,6 +960,13 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  				    kvm->debugfs_dentry, stat_data,
>  				    &stat_fops_per_vm);
>  	}
> +
> +	ret = kvm_arch_create_vm_debugfs(kvm);
> +	if (ret) {
> +		kvm_destroy_vm_debugfs(kvm);
> +		return i;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -980,6 +987,17 @@ void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
>  {
>  }
>  
> +/*
> + * Called after per-vm debugfs created.  When called kvm->debugfs_dentry should
> + * be setup already, so we can create arch-specific debugfs entries under it.
> + * Cleanup should be automatic done in kvm_destroy_vm_debugfs() recursively, so
> + * a per-arch destroy interface is not needed.
> + */
> +int __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)

This should be a void function, nothing should matter if creating
debugfs files succeeds or not.

As proof, your one implementation always returned 0 :)

thanks,

greg k-h
