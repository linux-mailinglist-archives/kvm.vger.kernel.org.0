Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1493468059C
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 06:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbjA3F0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 00:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbjA3F0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 00:26:41 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD22241EA
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 21:26:35 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t13-20020a056902018d00b0074747131938so11906203ybh.12
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 21:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b/vIkIPl5nRj/3hPy3c/U0PXxxrhFi67btaNOzIv4hA=;
        b=D7SxTMVpdE8OPU4Q8lhHRcsgMpDnY1lwmr2KK3l7i/bP6j+o5A3rsWdRpR2th82Tw7
         3Na5KNK1Stogf6axURA9XxIaCe3/IFgJehhOLeBTGm9/p382ok+02Xo2ovXAwG+kGbvD
         BmYmXY5hlLXG+XKrP7NNkk58y3fUL7ev3IABImxVQG/7/RdSHdFyuSpnpPb537H0OIPo
         ixo6e9FQ/K1A5UG1StdJkIVOHUhcREtuoRy1Ik+eIze4N8mllpTjrSq6abcsckZ7nOZ/
         sLroSxpo5sn2CdacRJ1G0xOA8ivhouUqU9Hqwci7GILS79bIuTqIG+D9QA2CHtpK2oXX
         ScUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/vIkIPl5nRj/3hPy3c/U0PXxxrhFi67btaNOzIv4hA=;
        b=TtZP6R6y3g1DI+rOv8Qmgm9tbpoaYpej9NVrX0HetUoVdEoakYg6y3gk7z3Cs8MCWo
         Aq2kThUbL0FGNjYRo1J8XSe0f7YW9liFJInpyA5Bi1gJ/l1Z2f8Ds/uZ4CtCN8dUsspl
         d/azN0advDzFJkXetqhq7KsCwRgq1EN/FVXDj56G+0MlVPH+3fm6L1qOKukWe5UmeKju
         JqcyxDv30kwsQCTdJ7GeGN7Ms7E2ubNiYcc/8fDhxuKEVjHawnCwD96ZP6EASnC5uwnA
         q7GAJaC2e5WmvldnX1AfjAo8lFthsNRfmkQ6bkhmxSjZmiLCDsm9P3fCE/YPHT3R72RY
         S5jg==
X-Gm-Message-State: AO0yUKVK37xgHWR5JIvjl/wEtyCEKPiSyI9slVDD9+01PkVUX1a70kam
        uK74XPMFpeeBJw+7YFIZFxoQsUD1rh/psqXweQ==
X-Google-Smtp-Source: AK7set+JlXdd4+lvDMPsWLbQWxCgCdL1TWQEwkw9Zl36rvKxocVcw2BCVuEm0lbxbrZEdORCPWSOnhc/TSAGSF3Dag==
X-Received: from ackerleytng-cloudtop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:b30])
 (user=ackerleytng job=sendgmr) by 2002:a81:77d6:0:b0:506:348b:88a2 with SMTP
 id s205-20020a8177d6000000b00506348b88a2mr3119463ywc.400.1675056394197; Sun,
 29 Jan 2023 21:26:34 -0800 (PST)
Date:   Mon, 30 Jan 2023 05:26:29 +0000
In-Reply-To: <20221202061347.1070246-2-chao.p.peng@linux.intel.com> (message
 from Chao Peng on Fri,  2 Dec 2022 14:13:39 +0800)
Mime-Version: 1.0
Message-ID: <diqzzga0fv96.fsf@ackerleytng-cloudtop-sg.c.googlers.com>
Subject: Re: [PATCH v10 1/9] mm: Introduce memfd_restricted system call to
 create restricted user memory
From:   Ackerley Tng <ackerleytng@google.com>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        pbonzini@redhat.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, arnd@arndb.de, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, x86@kernel.org, hpa@zytor.com,
        hughd@google.com, jlayton@kernel.org, bfields@fieldses.org,
        akpm@linux-foundation.org, shuah@kernel.org, rppt@kernel.org,
        steven.price@arm.com, mail@maciej.szmigiero.name, vbabka@suse.cz,
        vannapurve@google.com, yu.c.zhang@linux.intel.com,
        chao.p.peng@linux.intel.com, kirill.shutemov@linux.intel.com,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, david@redhat.com, aarcange@redhat.com,
        ddutile@redhat.com, dhildenb@redhat.com, qperret@google.com,
        tabba@google.com, michael.roth@amd.com, mhocko@suse.com,
        wei.w.wang@intel.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> +static int restrictedmem_getattr(struct user_namespace *mnt_userns,
> +				 const struct path *path, struct kstat *stat,
> +				 u32 request_mask, unsigned int query_flags)
> +{
> +	struct inode *inode = d_inode(path->dentry);
> +	struct restrictedmem_data *data = inode->i_mapping->private_data;
> +	struct file *memfd = data->memfd;
> +
> +	return memfd->f_inode->i_op->getattr(mnt_userns, path, stat,
> +					     request_mask, query_flags);

Instead of calling shmem's getattr() with path, we should be using the
the memfd's path.

Otherwise, shmem's getattr() will use restrictedmem's inode instead of
shmem's inode. The private fields will be of the wrong type, and the
host will crash when shmem_is_huge() does SHMEM_SB(inode->i_sb)->huge),
since inode->i_sb->s_fs_info is NULL for the restrictedmem's superblock.

Here's the patch:

diff --git a/mm/restrictedmem.c b/mm/restrictedmem.c
index 37191cd9eed1..06b72d593bd8 100644
--- a/mm/restrictedmem.c
+++ b/mm/restrictedmem.c
@@ -84,7 +84,7 @@ static int restrictedmem_getattr(struct user_namespace  
*mnt_userns,
  	struct restrictedmem *rm = inode->i_mapping->private_data;
  	struct file *memfd = rm->memfd;

-	return memfd->f_inode->i_op->getattr(mnt_userns, path, stat,
+	return memfd->f_inode->i_op->getattr(mnt_userns, &memfd->f_path, stat,
  					     request_mask, query_flags);
  }

> +}
> +
> +static int restrictedmem_setattr(struct user_namespace *mnt_userns,
> +				 struct dentry *dentry, struct iattr *attr)
> +{
> +	struct inode *inode = d_inode(dentry);
> +	struct restrictedmem_data *data = inode->i_mapping->private_data;
> +	struct file *memfd = data->memfd;
> +	int ret;
> +
> +	if (attr->ia_valid & ATTR_SIZE) {
> +		if (memfd->f_inode->i_size)
> +			return -EPERM;
> +
> +		if (!PAGE_ALIGNED(attr->ia_size))
> +			return -EINVAL;
> +	}
> +
> +	ret = memfd->f_inode->i_op->setattr(mnt_userns,
> +					    file_dentry(memfd), attr);
> +	return ret;
> +}
> +
> +static const struct inode_operations restrictedmem_iops = {
> +	.getattr = restrictedmem_getattr,
> +	.setattr = restrictedmem_setattr,
> +};
