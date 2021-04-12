Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6A935D162
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbhDLTqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbhDLTqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:46:14 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3731C061756
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 12:45:54 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id e186so14679300iof.7
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 12:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B7KsnuqX1tMVa7CNRLOYfstoaps6KxSMGtP6YE/qF0c=;
        b=F1rwdFEdrbTON7EFVhjWrta4FXNt4xiBG11DCZE6tmpywJNrn62wy1DNJ6ZAN95A9V
         bGVUpAQrXgqqymxO94o7DCcAJwjbt2vHQVA2BVk9rUkQwrXMvMCc0dJT5WdEqh9juTSb
         l+vP0c6hqFQDyaNyW9/L8cNIrIj1wpzJnvAFB/wPbBrD00DCHqP2K1i03l+IOLvVDzJd
         RmxDwLMe50HEwVuBrEJttku3Ar4612quZ5CGC8X94+A+9vTxIYAvCddTSWYgmwcj9yBj
         rtIDkcZ1w0fZ15XEVftf0UJhWtp3lYLkoJkabDwwQtFYHRE1OXiOMOtwG3abigWip5bF
         B/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B7KsnuqX1tMVa7CNRLOYfstoaps6KxSMGtP6YE/qF0c=;
        b=QRwWRrtut5vAO4JF//H+dv8FtCurKm5ef4RcUusqW02gcA+XVX0HHdSKnn+Q36L8VA
         +SGruuAJutGwK1tnj1ZJn6DbM7hjxVgsStrha0GT0xw6lePLrV1Ui8oRlIttKLrFrAwe
         dE2fBD73PS/DwoFOQ4un5ZFy4ui/6MqkIpmLeTdbQCe+WpHHp+YQcAm25PHlhV93Sthj
         jG+xtNKukvM/j+PGMg6VmUvLYJohmk60UhMjpE5tM3Mzi/iURdy8g7zUrPm3Fnye6ogt
         Hh/vxvqGG4IcysMLzVZ6oos9HaeJaC7izFmgq4wD1SSYfXrQWPBJouNZGepT3GSzMxGx
         Uzvg==
X-Gm-Message-State: AOAM5321v6SK8Tw643B5gR9s1/yEVPYOFVMhUCjpNh4DQaUC3tgQ3BTS
        aEWoFvcx+2OiGhtM1QSWZ/63oPyf4TwjnRuBeTHU6A==
X-Google-Smtp-Source: ABdhPJxsScZpE+IxCJkxZyiB0kec+h9n1YkF/o6JXJmqwG38mZkz89D4zHh1e1DL1B+gNo2G/Wt2Gt46rd7l6geR664=
X-Received: by 2002:a5d:83cf:: with SMTP id u15mr23823722ior.34.1618256754215;
 Mon, 12 Apr 2021 12:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210409220750.1972030-1-srutherford@google.com> <202104111658.4flRcgh7-lkp@intel.com>
In-Reply-To: <202104111658.4flRcgh7-lkp@intel.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 12:45:17 -0700
Message-ID: <CABayD+fAfLsNb5yev8AJMEV9Bug-UWM-M-1MxkBDruHkO10rdg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: SVM: Add support for KVM_SEV_SEND_CANCEL command
To:     kernel test robot <lkp@intel.com>
Cc:     KVM list <kvm@vger.kernel.org>, kbuild-all@lists.01.org,
        LKML <linux-kernel@vger.kernel.org>,
        Nathan Tempelman <natet@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 11, 2021 at 1:56 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Steve,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on kvm/queue]
> [also build test ERROR on vhost/linux-next cryptodev/master linux/master linus/master v5.12-rc6 next-20210409]
> [cannot apply to crypto/master]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Steve-Rutherford/KVM-SVM-Add-support-for-KVM_SEV_SEND_CANCEL-command/20210410-060941
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/0day-ci/linux/commit/16f9122ec5c3ee772f1edb80c2c2526650b60868
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Steve-Rutherford/KVM-SVM-Add-support-for-KVM_SEV_SEND_CANCEL-command/20210410-060941
>         git checkout 16f9122ec5c3ee772f1edb80c2c2526650b60868
>         # save the attached .config to linux build tree
>         make W=1 ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    drivers/crypto/ccp/sev-dev.c: In function 'sev_cmd_buffer_len':
> >> drivers/crypto/ccp/sev-dev.c:132:7: error: 'SEV_SEND_CANCEL' undeclared (first use in this function); did you mean 'SEV_CMD_SEND_CANCEL'?
>      132 |  case SEV_SEND_CANCEL:    return sizeof(struct sev_data_send_cancel);
>          |       ^~~~~~~~~~~~~~~
>          |       SEV_CMD_SEND_CANCEL
>    drivers/crypto/ccp/sev-dev.c:132:7: note: each undeclared identifier is reported only once for each function it appears in
>
>
> vim +132 drivers/crypto/ccp/sev-dev.c
>
>    100
>    101  static int sev_cmd_buffer_len(int cmd)
>    102  {
>    103          switch (cmd) {
>    104          case SEV_CMD_INIT:                      return sizeof(struct sev_data_init);
>    105          case SEV_CMD_PLATFORM_STATUS:           return sizeof(struct sev_user_data_status);
>    106          case SEV_CMD_PEK_CSR:                   return sizeof(struct sev_data_pek_csr);
>    107          case SEV_CMD_PEK_CERT_IMPORT:           return sizeof(struct sev_data_pek_cert_import);
>    108          case SEV_CMD_PDH_CERT_EXPORT:           return sizeof(struct sev_data_pdh_cert_export);
>    109          case SEV_CMD_LAUNCH_START:              return sizeof(struct sev_data_launch_start);
>    110          case SEV_CMD_LAUNCH_UPDATE_DATA:        return sizeof(struct sev_data_launch_update_data);
>    111          case SEV_CMD_LAUNCH_UPDATE_VMSA:        return sizeof(struct sev_data_launch_update_vmsa);
>    112          case SEV_CMD_LAUNCH_FINISH:             return sizeof(struct sev_data_launch_finish);
>    113          case SEV_CMD_LAUNCH_MEASURE:            return sizeof(struct sev_data_launch_measure);
>    114          case SEV_CMD_ACTIVATE:                  return sizeof(struct sev_data_activate);
>    115          case SEV_CMD_DEACTIVATE:                return sizeof(struct sev_data_deactivate);
>    116          case SEV_CMD_DECOMMISSION:              return sizeof(struct sev_data_decommission);
>    117          case SEV_CMD_GUEST_STATUS:              return sizeof(struct sev_data_guest_status);
>    118          case SEV_CMD_DBG_DECRYPT:               return sizeof(struct sev_data_dbg);
>    119          case SEV_CMD_DBG_ENCRYPT:               return sizeof(struct sev_data_dbg);
>    120          case SEV_CMD_SEND_START:                return sizeof(struct sev_data_send_start);
>    121          case SEV_CMD_SEND_UPDATE_DATA:          return sizeof(struct sev_data_send_update_data);
>    122          case SEV_CMD_SEND_UPDATE_VMSA:          return sizeof(struct sev_data_send_update_vmsa);
>    123          case SEV_CMD_SEND_FINISH:               return sizeof(struct sev_data_send_finish);
>    124          case SEV_CMD_RECEIVE_START:             return sizeof(struct sev_data_receive_start);
>    125          case SEV_CMD_RECEIVE_FINISH:            return sizeof(struct sev_data_receive_finish);
>    126          case SEV_CMD_RECEIVE_UPDATE_DATA:       return sizeof(struct sev_data_receive_update_data);
>    127          case SEV_CMD_RECEIVE_UPDATE_VMSA:       return sizeof(struct sev_data_receive_update_vmsa);
>    128          case SEV_CMD_LAUNCH_UPDATE_SECRET:      return sizeof(struct sev_data_launch_secret);
>    129          case SEV_CMD_DOWNLOAD_FIRMWARE:         return sizeof(struct sev_data_download_firmware);
>    130          case SEV_CMD_GET_ID:                    return sizeof(struct sev_data_get_id);
>    131          case SEV_CMD_ATTESTATION_REPORT:        return sizeof(struct sev_data_attestation_report);
>  > 132          case SEV_SEND_CANCEL:                           return sizeof(struct sev_data_send_cancel);
>    133          default:                                return 0;
>    134          }
>    135
>    136          return 0;
>    137  }
>    138
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Ugh, forgot to amend. V3 sent.
