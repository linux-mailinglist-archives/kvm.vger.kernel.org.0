Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D948D7428FD
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 16:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjF2O7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 10:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjF2O7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 10:59:19 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91C92D56;
        Thu, 29 Jun 2023 07:59:17 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id F1E835C0494;
        Thu, 29 Jun 2023 10:59:16 -0400 (EDT)
Received: from imap44 ([10.202.2.94])
  by compute2.internal (MEProxy); Thu, 29 Jun 2023 10:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1688050756; x=1688137156; bh=4RA89kqZ3S+rJWn5LuAjD6umi6utLV4mDPm
        YeJZiOEI=; b=EZoZQz0byfbeFauuzWXjEkpbPBhjVIc2tNhUQylUAN2f+43Gurt
        n+t+9/77hHAgOuso3N/L6VfdwZXxIrci7vH/+fou0vjAqFssxWu/NF7S0nyLbYtt
        GY5IFVJx1fYKzicsqG9QCjrj410b/gQU2jDGsU/xJzUnV4P0chMEhEgbq3ONibTL
        LhwzN+AV9WKCoELJ+8QgCbCZDzdHyZDrY3PFzIwS5eNpPhgGGaMnCikPoNJkp5Ni
        V26Ts/lWguvH307ajOf/eaevwj5BxI/XI61UjipnM79mWXE9JrPVrFZPAuh9XpSi
        Ds54TRh5W2yfE2vtY7yenR35xj+dd3wmqyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1688050756; x=1688137156; bh=4RA89kqZ3S+rJWn5LuAjD6umi6utLV4mDPm
        YeJZiOEI=; b=EPyW1skajWX9WAXYUoPKesSBByK/voz212W+yYCev++NRdnO/qF
        r9pdF06GJXY4g/S+a5VE+uiDbZ85F9crT09vRg72e8uz22p/bl9S1E0zm7Yo/DL1
        ik9FgzOh6h/+eRnQ+lsoJX/QBnBv77ANi8BZeeSh4iC7HtKh/FrrTa+wpkJX4Dlb
        criFFkUydyrZ3pdFaC877A/2cq7V7q1B4F36lYjxMMsTvpoYmqDtxtiDA529HZ5e
        cy3znDpiEBt6vAy01rb0cB9B+7dCWgJDDkjPLJkSIGQYORhwAR1qrYXGjy4cEqvG
        Ui/DVBnE4E7Xsr2J5+2c+Lp8drke+BKQ1wA==
X-ME-Sender: <xms:RJydZGMnii_hqdvxP_FGiKQo7PaWTSgfI5iLPxrEFb-dTS49ppmSqw>
    <xme:RJydZE_Tb87f-zdIA6cPqeXCCVi0KcLsNMv8N0gGCvrbxblA7zs_rfWgvL8OfujrV
    zyd6XgM4QGglynQjt0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrtdeggdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedflfhi
    rgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
    eqnecuggftrfgrthhtvghrnhepudduveffgeffteeiffdtfedtfeetjeffueejhefffefh
    heeuudeitdethfekkedvnecuffhomhgrihhnpedufhdrthhfnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhl
    hihgohgrthdrtghomh
X-ME-Proxy: <xmx:RJydZNRKqqPcxBMo5nagLNXam3mwUFxh5IYl2_igZn93NjvRSka1FQ>
    <xmx:RJydZGvAD8d2hkKOiXE91aebPe1qI2q9nuRQs5w3Pip_VK7qASl5nQ>
    <xmx:RJydZOfTfFGw_82oPF683gqhzv6KYcLp8rd8W8joKxr0RGY3ZcLcZQ>
    <xmx:RJydZN4Bx0ZmZTWguhc8FY8e3AnPoChFLvhRpyGZkm6CxBRMIjfuEA>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id ECBBC36A0073; Thu, 29 Jun 2023 10:59:15 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-499-gf27bbf33e2-fm-20230619.001-gf27bbf33
Mime-Version: 1.0
Message-Id: <f588f39d-0af7-4ab2-b28e-b53de1fc9d6b@app.fastmail.com>
In-Reply-To: <CABgObfYLnhW0qrPvFnMW_B9xZzLF6Ysn2uL4w9B815fUNVKK5A@mail.gmail.com>
References: <20230626074919.1871944-1-chenhuacai@loongson.cn>
 <CABgObfYLnhW0qrPvFnMW_B9xZzLF6Ysn2uL4w9B815fUNVKK5A@mail.gmail.com>
Date:   Thu, 29 Jun 2023 22:58:53 +0800
From:   "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Huacai Chen" <chenhuacai@loongson.cn>
Cc:     "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
        "Huacai Chen" <chenhuacai@kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        kvm@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] MIPS: KVM: Fix NULL pointer dereference
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



=E5=9C=A82023=E5=B9=B46=E6=9C=8826=E6=97=A5=E5=85=AD=E6=9C=88 =E4=B8=8B=E5=
=8D=886:33=EF=BC=8CPaolo Bonzini=E5=86=99=E9=81=93=EF=BC=9A
> On Mon, Jun 26, 2023 at 9:59=E2=80=AFAM Huacai Chen <chenhuacai@loongs=
on.cn> wrote:
>>
>> After commit 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support")=
 we
>> get a NULL pointer dereference when creating a KVM guest:
>
> To be honest, a bug that needed 2 years to be reproduced is probably a
> sign that KVM/MIPS has no users. Any objections to removing it
> altogether?

I am frequently doing boot test with QEMU & using MIPS KVM to test kerne=
l on Loongson.

Though I haven't upgrade host kernel for a while, that's why the issue w=
asn't caught by me.

Also AFAIK there are several Loongson cloud service still using KVM.

So I don't want to see it go.

Thanks
Jiaxun=20

>
> Paolo
>
>>
>> [  146.243409] Starting KVM with MIPS VZ extensions
>> [  149.849151] CPU 3 Unable to handle kernel paging request at virtua=
l address 0000000000000300, epc =3D=3D ffffffffc06356ec, ra =3D=3D fffff=
fffc063568c
>> [  149.849177] Oops[#1]:
>> [  149.849182] CPU: 3 PID: 2265 Comm: qemu-system-mip Not tainted 6.4=
.0-rc3+ #1671
>> [  149.849188] Hardware name: THTF CX TL630 Series/THTF-LS3A4000-7A10=
00-ML4A, BIOS KL4.1F.TF.D.166.201225.R 12/25/2020
>> [  149.849192] $ 0   : 0000000000000000 000000007400cce0 000000000040=
0004 ffffffff8119c740
>> [  149.849209] $ 4   : 000000007400cce1 000000007400cce1 000000000000=
0000 0000000000000000
>> [  149.849221] $ 8   : 000000240058bb36 ffffffff81421ac0 000000000000=
0000 0000000000400dc0
>> [  149.849233] $12   : 9800000102a07cc8 ffffffff80e40e38 000000000000=
0001 0000000000400dc0
>> [  149.849245] $16   : 0000000000000000 9800000106cd0000 9800000106cd=
0000 9800000100cce000
>> [  149.849257] $20   : ffffffffc0632b28 ffffffffc05b31b0 9800000100cc=
ca00 0000000000400000
>> [  149.849269] $24   : 9800000106cd09ce ffffffff802f69d0
>> [  149.849281] $28   : 9800000102a04000 9800000102a07cd0 98000001106a=
8000 ffffffffc063568c
>> [  149.849293] Hi    : 00000335b2111e66
>> [  149.849295] Lo    : 6668d90061ae0ae9
>> [  149.849298] epc   : ffffffffc06356ec kvm_vz_vcpu_setup+0xc4/0x328 =
[kvm]
>> [  149.849324] ra    : ffffffffc063568c kvm_vz_vcpu_setup+0x64/0x328 =
[kvm]
>> [  149.849336] Status: 7400cce3 KX SX UX KERNEL EXL IE
>> [  149.849351] Cause : 1000000c (ExcCode 03)
>> [  149.849354] BadVA : 0000000000000300
>> [  149.849357] PrId  : 0014c004 (ICT Loongson-3)
>> [  149.849360] Modules linked in: kvm nfnetlink_queue nfnetlink_log n=
fnetlink fuse sha256_generic libsha256 cfg80211 rfkill binfmt_misc vfat =
fat snd_hda_codec_hdmi input_leds led_class snd_hda_intel snd_intel_dspc=
fg snd_hda_codec snd_hda_core snd_pcm snd_timer snd serio_raw xhci_pci r=
adeon drm_suballoc_helper drm_display_helper xhci_hcd ip_tables x_tables
>> [  149.849432] Process qemu-system-mip (pid: 2265, threadinfo=3D00000=
000ae2982d2, task=3D0000000038e09ad4, tls=3D000000ffeba16030)
>> [  149.849439] Stack : 9800000000000003 9800000100ccca00 9800000100cc=
c000 ffffffffc062cef4
>> [  149.849453]         9800000102a07d18 c89b63a7ab338e00 000000000000=
0000 ffffffff811a0000
>> [  149.849465]         0000000000000000 9800000106cd0000 ffffffff80e5=
9938 98000001106a8920
>> [  149.849476]         ffffffff80e57f30 ffffffffc062854c ffffffff811a=
0000 9800000102bf4240
>> [  149.849488]         ffffffffc05b0000 ffffffff80e3a798 000000ff7800=
0000 000000ff78000010
>> [  149.849500]         0000000000000255 98000001021f7de0 98000001023f=
0078 ffffffff81434000
>> [  149.849511]         0000000000000000 0000000000000000 9800000102ae=
0000 980000025e92ae28
>> [  149.849523]         0000000000000000 c89b63a7ab338e00 000000000000=
0001 ffffffff8119dce0
>> [  149.849535]         000000ff78000010 ffffffff804f3d3c 9800000102a0=
7eb0 0000000000000255
>> [  149.849546]         0000000000000000 ffffffff8049460c 000000ff7800=
0010 0000000000000255
>> [  149.849558]         ...
>> [  149.849565] Call Trace:
>> [  149.849567] [<ffffffffc06356ec>] kvm_vz_vcpu_setup+0xc4/0x328 [kvm]
>> [  149.849586] [<ffffffffc062cef4>] kvm_arch_vcpu_create+0x184/0x228 =
[kvm]
>> [  149.849605] [<ffffffffc062854c>] kvm_vm_ioctl+0x64c/0xf28 [kvm]
>> [  149.849623] [<ffffffff805209c0>] sys_ioctl+0xc8/0x118
>> [  149.849631] [<ffffffff80219eb0>] syscall_common+0x34/0x58
>>
>> The root cause is the deletion of kvm_mips_commpage_init() leaves vcp=
u->
>> arch.cop0 NULL. So fix it by make cop0 from a pointer to an embed obj=
ect.
>>
>> Fixes: 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support")
>> Cc: stable@vger.kernel.org
>> Suggested-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
>> ---
>>  arch/mips/include/asm/kvm_host.h |  6 +++---
>>  arch/mips/kvm/emulate.c          | 22 +++++++++++-----------
>>  arch/mips/kvm/mips.c             | 16 ++++++++--------
>>  arch/mips/kvm/trace.h            |  8 ++++----
>>  arch/mips/kvm/vz.c               | 20 ++++++++++----------
>>  5 files changed, 36 insertions(+), 36 deletions(-)
>>
>> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm=
/kvm_host.h
>> index 957121a495f0..04cedf9f8811 100644
>> --- a/arch/mips/include/asm/kvm_host.h
>> +++ b/arch/mips/include/asm/kvm_host.h
>> @@ -317,7 +317,7 @@ struct kvm_vcpu_arch {
>>         unsigned int aux_inuse;
>>
>>         /* COP0 State */
>> -       struct mips_coproc *cop0;
>> +       struct mips_coproc cop0;
>>
>>         /* Resume PC after MMIO completion */
>>         unsigned long io_pc;
>> @@ -698,7 +698,7 @@ static inline bool kvm_mips_guest_can_have_fpu(st=
ruct kvm_vcpu_arch *vcpu)
>>  static inline bool kvm_mips_guest_has_fpu(struct kvm_vcpu_arch *vcpu)
>>  {
>>         return kvm_mips_guest_can_have_fpu(vcpu) &&
>> -               kvm_read_c0_guest_config1(vcpu->cop0) & MIPS_CONF1_FP;
>> +               kvm_read_c0_guest_config1(&vcpu->cop0) & MIPS_CONF1_F=
P;
>>  }
>>
>>  static inline bool kvm_mips_guest_can_have_msa(struct kvm_vcpu_arch =
*vcpu)
>> @@ -710,7 +710,7 @@ static inline bool kvm_mips_guest_can_have_msa(st=
ruct kvm_vcpu_arch *vcpu)
>>  static inline bool kvm_mips_guest_has_msa(struct kvm_vcpu_arch *vcpu)
>>  {
>>         return kvm_mips_guest_can_have_msa(vcpu) &&
>> -               kvm_read_c0_guest_config3(vcpu->cop0) & MIPS_CONF3_MS=
A;
>> +               kvm_read_c0_guest_config3(&vcpu->cop0) & MIPS_CONF3_M=
SA;
>>  }
>>
>>  struct kvm_mips_callbacks {
>> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
>> index edaec93a1a1f..e64372b8f66a 100644
>> --- a/arch/mips/kvm/emulate.c
>> +++ b/arch/mips/kvm/emulate.c
>> @@ -312,7 +312,7 @@ int kvm_get_badinstrp(u32 *opc, struct kvm_vcpu *=
vcpu, u32 *out)
>>   */
>>  int kvm_mips_count_disabled(struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>
>>         return  (vcpu->arch.count_ctl & KVM_REG_MIPS_COUNT_CTL_DC) ||
>>                 (kvm_read_c0_guest_cause(cop0) & CAUSEF_DC);
>> @@ -384,7 +384,7 @@ static inline ktime_t kvm_mips_count_time(struct =
kvm_vcpu *vcpu)
>>   */
>>  static u32 kvm_mips_read_count_running(struct kvm_vcpu *vcpu, ktime_=
t now)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         ktime_t expires, threshold;
>>         u32 count, compare;
>>         int running;
>> @@ -444,7 +444,7 @@ static u32 kvm_mips_read_count_running(struct kvm=
_vcpu *vcpu, ktime_t now)
>>   */
>>  u32 kvm_mips_read_count(struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>
>>         /* If count disabled just read static copy of count */
>>         if (kvm_mips_count_disabled(vcpu))
>> @@ -502,7 +502,7 @@ ktime_t kvm_mips_freeze_hrtimer(struct kvm_vcpu *=
vcpu, u32 *count)
>>  static void kvm_mips_resume_hrtimer(struct kvm_vcpu *vcpu,
>>                                     ktime_t now, u32 count)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         u32 compare;
>>         u64 delta;
>>         ktime_t expire;
>> @@ -603,7 +603,7 @@ int kvm_mips_restore_hrtimer(struct kvm_vcpu *vcp=
u, ktime_t before,
>>   */
>>  void kvm_mips_write_count(struct kvm_vcpu *vcpu, u32 count)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         ktime_t now;
>>
>>         /* Calculate bias */
>> @@ -649,7 +649,7 @@ void kvm_mips_init_count(struct kvm_vcpu *vcpu, u=
nsigned long count_hz)
>>   */
>>  int kvm_mips_set_count_hz(struct kvm_vcpu *vcpu, s64 count_hz)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         int dc;
>>         ktime_t now;
>>         u32 count;
>> @@ -696,7 +696,7 @@ int kvm_mips_set_count_hz(struct kvm_vcpu *vcpu, =
s64 count_hz)
>>   */
>>  void kvm_mips_write_compare(struct kvm_vcpu *vcpu, u32 compare, bool=
 ack)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         int dc;
>>         u32 old_compare =3D kvm_read_c0_guest_compare(cop0);
>>         s32 delta =3D compare - old_compare;
>> @@ -779,7 +779,7 @@ void kvm_mips_write_compare(struct kvm_vcpu *vcpu=
, u32 compare, bool ack)
>>   */
>>  static ktime_t kvm_mips_count_disable(struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         u32 count;
>>         ktime_t now;
>>
>> @@ -806,7 +806,7 @@ static ktime_t kvm_mips_count_disable(struct kvm_=
vcpu *vcpu)
>>   */
>>  void kvm_mips_count_disable_cause(struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>
>>         kvm_set_c0_guest_cause(cop0, CAUSEF_DC);
>>         if (!(vcpu->arch.count_ctl & KVM_REG_MIPS_COUNT_CTL_DC))
>> @@ -826,7 +826,7 @@ void kvm_mips_count_disable_cause(struct kvm_vcpu=
 *vcpu)
>>   */
>>  void kvm_mips_count_enable_cause(struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         u32 count;
>>
>>         kvm_clear_c0_guest_cause(cop0, CAUSEF_DC);
>> @@ -852,7 +852,7 @@ void kvm_mips_count_enable_cause(struct kvm_vcpu =
*vcpu)
>>   */
>>  int kvm_mips_set_count_ctl(struct kvm_vcpu *vcpu, s64 count_ctl)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         s64 changed =3D count_ctl ^ vcpu->arch.count_ctl;
>>         s64 delta;
>>         ktime_t expire, now;
>> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
>> index 884be4ef99dc..aa5583a7b05b 100644
>> --- a/arch/mips/kvm/mips.c
>> +++ b/arch/mips/kvm/mips.c
>> @@ -649,7 +649,7 @@ static int kvm_mips_copy_reg_indices(struct kvm_v=
cpu *vcpu, u64 __user *indices)
>>  static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
>>                             const struct kvm_one_reg *reg)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         struct mips_fpu_struct *fpu =3D &vcpu->arch.fpu;
>>         int ret;
>>         s64 v;
>> @@ -761,7 +761,7 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
>>  static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
>>                             const struct kvm_one_reg *reg)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         struct mips_fpu_struct *fpu =3D &vcpu->arch.fpu;
>>         s64 v;
>>         s64 vs[2];
>> @@ -1086,7 +1086,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kv=
m, long ext)
>>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>>  {
>>         return kvm_mips_pending_timer(vcpu) ||
>> -               kvm_read_c0_guest_cause(vcpu->arch.cop0) & C_TI;
>> +               kvm_read_c0_guest_cause(&vcpu->arch.cop0) & C_TI;
>>  }
>>
>>  int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
>> @@ -1110,7 +1110,7 @@ int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vc=
pu)
>>         kvm_debug("\thi: 0x%08lx\n", vcpu->arch.hi);
>>         kvm_debug("\tlo: 0x%08lx\n", vcpu->arch.lo);
>>
>> -       cop0 =3D vcpu->arch.cop0;
>> +       cop0 =3D &vcpu->arch.cop0;
>>         kvm_debug("\tStatus: 0x%08x, Cause: 0x%08x\n",
>>                   kvm_read_c0_guest_status(cop0),
>>                   kvm_read_c0_guest_cause(cop0));
>> @@ -1232,7 +1232,7 @@ static int __kvm_mips_handle_exit(struct kvm_vc=
pu *vcpu)
>>
>>         case EXCCODE_TLBS:
>>                 kvm_debug("TLB ST fault:  cause %#x, status %#x, PC: =
%p, BadVaddr: %#lx\n",
>> -                         cause, kvm_read_c0_guest_status(vcpu->arch.=
cop0), opc,
>> +                         cause, kvm_read_c0_guest_status(&vcpu->arch=
.cop0), opc,
>>                           badvaddr);
>>
>>                 ++vcpu->stat.tlbmiss_st_exits;
>> @@ -1304,7 +1304,7 @@ static int __kvm_mips_handle_exit(struct kvm_vc=
pu *vcpu)
>>                 kvm_get_badinstr(opc, vcpu, &inst);
>>                 kvm_err("Exception Code: %d, not yet handled, @ PC: %=
p, inst: 0x%08x  BadVaddr: %#lx Status: %#x\n",
>>                         exccode, opc, inst, badvaddr,
>> -                       kvm_read_c0_guest_status(vcpu->arch.cop0));
>> +                       kvm_read_c0_guest_status(&vcpu->arch.cop0));
>>                 kvm_arch_vcpu_dump_regs(vcpu);
>>                 run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
>>                 ret =3D RESUME_HOST;
>> @@ -1377,7 +1377,7 @@ int noinstr kvm_mips_handle_exit(struct kvm_vcp=
u *vcpu)
>>  /* Enable FPU for guest and restore context */
>>  void kvm_own_fpu(struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         unsigned int sr, cfg5;
>>
>>         preempt_disable();
>> @@ -1421,7 +1421,7 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
>>  /* Enable MSA for guest and restore context */
>>  void kvm_own_msa(struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         unsigned int sr, cfg5;
>>
>>         preempt_disable();
>> diff --git a/arch/mips/kvm/trace.h b/arch/mips/kvm/trace.h
>> index a8c7fd7bf6d2..136c3535a1cb 100644
>> --- a/arch/mips/kvm/trace.h
>> +++ b/arch/mips/kvm/trace.h
>> @@ -322,11 +322,11 @@ TRACE_EVENT_FN(kvm_guest_mode_change,
>>             ),
>>
>>             TP_fast_assign(
>> -                       __entry->epc =3D kvm_read_c0_guest_epc(vcpu->=
arch.cop0);
>> +                       __entry->epc =3D kvm_read_c0_guest_epc(&vcpu-=
>arch.cop0);
>>                         __entry->pc =3D vcpu->arch.pc;
>> -                       __entry->badvaddr =3D kvm_read_c0_guest_badva=
ddr(vcpu->arch.cop0);
>> -                       __entry->status =3D kvm_read_c0_guest_status(=
vcpu->arch.cop0);
>> -                       __entry->cause =3D kvm_read_c0_guest_cause(vc=
pu->arch.cop0);
>> +                       __entry->badvaddr =3D kvm_read_c0_guest_badva=
ddr(&vcpu->arch.cop0);
>> +                       __entry->status =3D kvm_read_c0_guest_status(=
&vcpu->arch.cop0);
>> +                       __entry->cause =3D kvm_read_c0_guest_cause(&v=
cpu->arch.cop0);
>>             ),
>>
>>             TP_printk("EPC: 0x%08lx PC: 0x%08lx Status: 0x%08x Cause:=
 0x%08x BadVAddr: 0x%08lx",
>> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
>> index 3d21cbfa7443..99d5a71e4300 100644
>> --- a/arch/mips/kvm/vz.c
>> +++ b/arch/mips/kvm/vz.c
>> @@ -422,7 +422,7 @@ static void _kvm_vz_restore_htimer(struct kvm_vcp=
u *vcpu,
>>   */
>>  static void kvm_vz_restore_timer(struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         u32 cause, compare;
>>
>>         compare =3D kvm_read_sw_gc0_compare(cop0);
>> @@ -517,7 +517,7 @@ static void _kvm_vz_save_htimer(struct kvm_vcpu *=
vcpu,
>>   */
>>  static void kvm_vz_save_timer(struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         u32 gctl0, compare, cause;
>>
>>         gctl0 =3D read_c0_guestctl0();
>> @@ -863,7 +863,7 @@ static unsigned long mips_process_maar(unsigned i=
nt op, unsigned long val)
>>
>>  static void kvm_write_maari(struct kvm_vcpu *vcpu, unsigned long val)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>
>>         val &=3D MIPS_MAARI_INDEX;
>>         if (val =3D=3D MIPS_MAARI_INDEX)
>> @@ -876,7 +876,7 @@ static enum emulation_result kvm_vz_gpsi_cop0(uni=
on mips_instruction inst,
>>                                               u32 *opc, u32 cause,
>>                                               struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         enum emulation_result er =3D EMULATE_DONE;
>>         u32 rt, rd, sel;
>>         unsigned long curr_pc;
>> @@ -1911,7 +1911,7 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *=
vcpu,
>>                               const struct kvm_one_reg *reg,
>>                               s64 *v)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         unsigned int idx;
>>
>>         switch (reg->id) {
>> @@ -2081,7 +2081,7 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *=
vcpu,
>>         case KVM_REG_MIPS_CP0_MAARI:
>>                 if (!cpu_guest_has_maar || cpu_guest_has_dyn_maar)
>>                         return -EINVAL;
>> -               *v =3D kvm_read_sw_gc0_maari(vcpu->arch.cop0);
>> +               *v =3D kvm_read_sw_gc0_maari(&vcpu->arch.cop0);
>>                 break;
>>  #ifdef CONFIG_64BIT
>>         case KVM_REG_MIPS_CP0_XCONTEXT:
>> @@ -2135,7 +2135,7 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *=
vcpu,
>>                               const struct kvm_one_reg *reg,
>>                               s64 v)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         unsigned int idx;
>>         int ret =3D 0;
>>         unsigned int cur, change;
>> @@ -2562,7 +2562,7 @@ static void kvm_vz_vcpu_load_tlb(struct kvm_vcp=
u *vcpu, int cpu)
>>
>>  static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         bool migrated, all;
>>
>>         /*
>> @@ -2704,7 +2704,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vc=
pu, int cpu)
>>
>>  static int kvm_vz_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>
>>         if (current->flags & PF_VCPU)
>>                 kvm_vz_vcpu_save_wired(vcpu);
>> @@ -3076,7 +3076,7 @@ static void kvm_vz_vcpu_uninit(struct kvm_vcpu =
*vcpu)
>>
>>  static int kvm_vz_vcpu_setup(struct kvm_vcpu *vcpu)
>>  {
>> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
>> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>>         unsigned long count_hz =3D 100*1000*1000; /* default to 100 M=
Hz */
>>
>>         /*
>> --
>> 2.39.3
>>

--=20
- Jiaxun
