Return-Path: <kvm+bounces-60586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA5CBF423C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 02:22:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8CC1E4ECB37
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 00:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF681DF963;
	Tue, 21 Oct 2025 00:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L4HqOt0C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391231C3F36;
	Tue, 21 Oct 2025 00:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761006125; cv=none; b=XAP7x78lm0ILEnUpIHP3NpLj3hmtenstC9HKxFoSI7PC8q1j4TJuO6hfJgZf1B4rsVkC1cIpPgEmpMhJCDY84QfHyPHKPPtdCEWJvBTjvV7TI2a9sqa1SWoBKNXl890oeeY1++yjZPPrnQBCkCIjJr9G3xdaeVDLiFHGDdBAM1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761006125; c=relaxed/simple;
	bh=gniUcxhHHv8VJQis2NF0KW9Zc/LbUVodB5Gu9z9Ujps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jaaw7w8p4ee2h+4V3iYIkDFKALv9NhUhvli2I1rMpVrjcPZHMCGaZ0FQdMhxbmqEr7jNYrCXUjH2EbbgFRYgfzTtuDUr2jqJb2VrX46nhFhll7NizSKhSoWi5gVqM4dFRDiX5WWtofoTFvrqooptaKatGsLMP2WCARESTKZDU8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L4HqOt0C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3C8C4CEFB;
	Tue, 21 Oct 2025 00:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761006122;
	bh=gniUcxhHHv8VJQis2NF0KW9Zc/LbUVodB5Gu9z9Ujps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L4HqOt0Cf8lR7nhoSqUxE/EWK6jdqN4LbNlwX/3vrGJAx5OO44ZqIoJwsL6bWggdk
	 hgC3wbF57mgLGUr/6S1E3ZAP8DjDS/QTjNJKxEybXXlS88oSLHfisDUjkvo5o5q/6q
	 KcjhAAEmjv/EHKZ3WFwFavg2zqIZyW3iA8QacGxkiFzFX8He27+hdzREcjiw2EqvRA
	 15eajcknZOpcQVbjVDZJdXbSpcLbomcQ9+QtGfDhEvMIK+nHPv+Jp36Ua3DTA6hvnE
	 8q5C5VNm+GwNfX5StVdmMVplBTwJsQEcweYHi9vyk+p+lOlqYaZWrA3R8Pzv7HZ420
	 pJQ+Kwz3lDluQ==
Date: Tue, 21 Oct 2025 01:21:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Aishwarya.TCV@arm.com
Subject: Re: [PATCH] KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3
 or v3 guests
Message-ID: <23072856-6b8c-41e2-93d1-ea8a240a7079@sirena.org.uk>
References: <20251007160704.1673584-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Hai4KbcOHSUNYB1M"
Content-Disposition: inline
In-Reply-To: <20251007160704.1673584-1-sascha.bischoff@arm.com>
X-Cookie: Every morning is a Smirnoff morning.


--Hai4KbcOHSUNYB1M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2025 at 04:07:13PM +0000, Sascha Bischoff wrote:
> The ICH_HCR_EL2 traps are used when running on GICv3 hardware, or when
> running a GICv3-based guest using FEAT_GCIE_LEGACY on GICv5
> hardware. When running a GICv2 guest on GICv3 hardware the traps are
> used to ensure that the guest never sees any part of GICv3 (only GICv2
> is visible to the guest), and when running a GICv3 guest they are used
> to trap in specific scenarios. They are not applicable for a
> GICv2-native guest, and won't be applicable for a(n upcoming) GICv5
> guest.

v6.18-rc2 introduces a failure in the KVM no-vgic-v3 selftest on what
appears to be all arm64 platforms with a GICv3 in all of VHE, nVHE and
pKVM modes:

# selftests: kvm: no-vgic-v3
# Random seed: 0x6b8b4567
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   arm64/no-vgic-v3.c:66: handled
#   pid=3D3469 tid=3D3469 errno=3D4 - Interrupted system call
#      1	0x0000000000402ff7: test_run_vcpu at no-vgic-v3.c:128
#      2	0x0000000000402213: test_guest_no_gicv3 at no-vgic-v3.c:155
#      3	 (inlined by) main at no-vgic-v3.c:174
#      4	0x0000ffff7fca7543: ?? ??:0
#      5	0x0000ffff7fca7617: ?? ??:0
#      6	0x00000000004023af: _start at ??:?
#   ICC_PMR_EL1 no read trap
not ok 25 selftests: kvm: no-vgic-v3 # exit=3D254

introduced by this patch, which is commit 3193287ddffb and which never
appeared in -next prior to being merged into mainline.

It didn't appear in -next since the arm64 KVM fixes tree is not directly
in -next and it was only pulled into Paolo's tree on Saturday, a few
hours before Paolo sent his pull request to Linus, so there was no
opportunity for it to be picked up.  As I've previously suggested it
does seem like it would be a good idea to include the fixes branches for
the KVM arch trees in -next (s390 is there, but I don't see the others),
and/or to have more cooking time between things being pulled into the
main KVM fixes branch and being sent to Linus.

Full log from one run:

   https://lava.sirena.org.uk/scheduler/job/1979313#L4115

bisect log:

# bad: [211ddde0823f1442e4ad052a2f30f050145ccada] Linux 6.18-rc2
# good: [e5f0a698b34ed76002dc5cff3804a61c80233a7a] Linux 6.17
# good: [5a6f65d1502551f84c158789e5d89299c78907c7] Merge tag 'bitmap-for-v6=
=2E18-rc2' of https://github.com/norov/linux
# good: [f406055cb18c6e299c4a783fc1effeb16be41803] Merge tag 'arm64-fixes' =
of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
# good: [5726b68473f7153a7f6294185e5998b7e2a230a2] ASoC: amd/sdw_utils: avo=
id NULL deref when devm_kasprintf() fails
# good: [7ea30958b3054f5e488fa0b33c352723f7ab3a2a] Merge tag 'vfs-6.18-rc2.=
fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs
# good: [98ac9cc4b4452ed7e714eddc8c90ac4ae5da1a09] Merge tag 'f2fs-fix-6.18=
-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs
# good: [6f3b6e91f7201e248d83232538db14d30100e9c7] Merge tag 'io_uring-6.18=
-20251016' of git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux
# good: [9b332cece987ee1790b2ed4c989e28162fa47860] Merge tag 'nfsd-6.18-1' =
of git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux
# good: [1f4a222b0e334540343fbb5d3eac4584a6bfe180] Remove long-stale ext3 d=
efconfig option
# good: [d5cda96d0130effd4255f7c5e720a58760a032a4] ASoC: codecs: wcd938x-sd=
w: remove redundant runtime pm calls
# good: [6370a996f308ea3276030769b7482b346e7cc7c1] ASoC: codecs: Fix gain s=
etting ranges for Renesas IDT821034 codec
# good: [ee70bacef1c6050e4836409927294d744dbcfa72] ASoC: nau8821: Avoid unn=
ecessary blocking in IRQ handler
# good: [dee4ef0ebe4dee655657ead30892aeca16462823] ASoC: qcom: sc8280xp: Ad=
d support for QCS615
# good: [3a8660878839faadb4f1a6dd72c3179c1df56787] Linux 6.18-rc1
# good: [0739473694c4878513031006829f1030ec850bc2] Merge tag 'for-6.18/hpfs=
-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/li=
nux-dm
# good: [8765f467912ff0d4832eeaf26ae573792da877e7] Merge tag 'irq_urgent_fo=
r_v6.18_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
# good: [67029a49db6c1f21106a1b5fcdd0ea234a6e0711] Merge tag 'trace-v6.18-3=
' of git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace
# good: [98906f9d850e4882004749eccb8920649dc98456] Merge tag 'rtc-6.18' of =
git://git.kernel.org/pub/scm/linux/kernel/git/abelloni/linux
# good: [8bd9238e511d02831022ff0270865c54ccc482d6] Merge tag 'ceph-for-6.18=
-rc1' of https://github.com/ceph/ceph-client
# good: [9591fdb0611dccdeeeeacb99d89f0098737d209b] Merge tag 'x86_core_for_=
v6.18_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
# good: [cd5a0afbdf8033dc83786315d63f8b325bdba2fd] Merge tag 'mailbox-v6.18=
' of git://git.kernel.org/pub/scm/linux/kernel/git/jassibrar/mailbox
# good: [ec714e371f22f716a04e6ecb2a24988c92b26911] Merge tag 'perf-tools-fo=
r-v6.18-1-2025-10-08' of git://git.kernel.org/pub/scm/linux/kernel/git/perf=
/perf-tools
# good: [5472d60c129f75282d94ae5ad072ee6dfb7c7246] Merge tag 'trace-v6.18-2=
' of git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace
# good: [0d97f2067c166eb495771fede9f7b73999c67f66] Merge tag 'for-linus' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/rmk/linux
# good: [18a7e218cfcdca6666e1f7356533e4c988780b57] Merge tag 'net-6.18-rc1'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
# good: [a8cdf51cda30f7461a98af821e8a28c5cb5f8878] Merge tag 'hardening-fix=
1-v6.18-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
# good: [a27539810e1e61efcfdeb51777ed875dc61e9d49] ASoC: rt722: add setting=
s for rt722VB
# good: [c746c3b5169831d7fb032a1051d8b45592ae8d78] Merge tag 'for-6.18-tag'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
# good: [56019d4ff8dd5ef16915c2605988c4022a46019c] Merge tag 'thermal-6.18-=
rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
# good: [6a74422b9710e987c7d6b85a1ade7330b1e61626] Merge tag 'mips_6.18' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/mips/linux
# good: [d104e3d17f7bfc505281f57f8c1a5589fca6ffe4] Merge tag 'cxl-for-6.18'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl
# good: [6093a688a07da07808f0122f9aa2a3eed250d853] Merge tag 'char-misc-6.1=
8-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
# good: [b41048485ee395edbbb69fc83491d314268f7bdb] Merge tag 'memblock-v6.1=
8-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
# good: [ba9dac987319d4f3969691dcf366ef19c9ed8281] Merge tag 'libnvdimm-for=
-6.18' of git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
# good: [7a405dbb0f036f8d1713ab9e7df0cd3137987b07] Merge tag 'mm-stable-202=
5-10-03-16-49' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
# good: [fd94619c43360eb44d28bd3ef326a4f85c600a07] Merge tag 'zonefs-6.18-r=
c1' of git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/zonefs
# good: [cbf33b8e0b360f667b17106c15d9e2aac77a76a1] Merge tag 'bpf-fixes' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
# good: [aaab61de1f1e44a2ab527e935474e2e03a0f6b08] ASoC: SOF: Intel: Read t=
he LLP via the associated Link DMA channel
# good: [d3479214c05dbd07bc56f8823e7bd8719fcd39a9] Merge tag 'backlight-nex=
t-6.18' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight
# good: [bace10b59624e6bd8d68bc9304357f292f1b3dcf] ASoC: SOF: ipc4-pcm: fix=
 start offset calculation for chain DMA
# good: [45ad27d9a6f7c620d8bbc80be3bab1faf37dfa0a] ASoC: SOF: Intel: hda-pc=
m: Place the constraint on period time instead of buffer time
# good: [080ffb4bec4d49cdedca11810395f8cad812471e] Merge tag 'i3c/for-6.18'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/i3c/linux
# good: [d5f74114114cb2cdbed75b91ca2fa4482c1d5611] Merge tag 'gpio-updates-=
for-v6.18-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux
# good: [50c19e20ed2ef359cf155a39c8462b0a6351b9fa] Merge tag 'nolibc-202509=
28-for-6.18-1' of git://git.kernel.org/pub/scm/linux/kernel/git/nolibc/linu=
x-nolibc
# good: [4b81e2eb9e4db8f6094c077d0c8b27c264901c1b] Merge tag 'timers-vdso-2=
025-09-29' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
# good: [22bdd6e68bbe270a916233ec5f34a13ae5e80ed9] Merge tag 'x86_apic_for_=
v6.18_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
# good: [417552999d0b6681ac30e117ae890828ca7e46b3] Merge tag 'powerpc-6.18-=
1' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux
# good: [9cc220a422113f665e13364be1411c7bba9e3e30] Merge tag 's390-6.18-1' =
of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
# good: [755fa5b4fb36627796af19932a432d343220ec63] Merge tag 'cgroup-for-6.=
18' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
# good: [30d4efb2f5a515a60fe6b0ca85362cbebea21e2f] Merge tag 'for-linus-6.1=
8-rc1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
# good: [feafee284579d29537a5a56ba8f23894f0463f3d] Merge tag 'arm64-upstrea=
m' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
# good: [449c2b302c8e200558619821ced46cc13cdb9aa6] Merge tag 'vfs-6.18-rc1.=
async' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs
# good: [1896ce8eb6c61824f6c1125d69d8fda1f44a22f8] Merge tag 'fsverity-for-=
linus' of git://git.kernel.org/pub/scm/fs/fsverity/linux
# good: [733a763dd8b3ac2858dd238a91bb3a2fdff4739e] ASoC: tlv320aic3x: Fix c=
lass-D initialization for tlv320aic3007
# good: [f8b9c819ea20d1101656a91ced843d9e47ba0630] ASoc: tas2783A: Fix an e=
rror code in probe()
# good: [e26387e950ee4486b4ed5728b5d3c1430c33ba67] ASoC: renesas: msiof: ig=
nore 1st FSERR
# good: [6be988660b474564c77cb6ff60776dafcd850a18] ASoc: tas2783A: Fix spel=
ling mistake "Perifpheral" -> "Peripheral"
# good: [82fd5dc99d63f948c59ac3b08137ef49125938bc] ASoC: dt-binding: Conver=
t MediaTek mt8183-mt6358 to DT schema
# good: [dc64b3d42cb361d4b39eb7cc73037fec52ef9676] ASoC: codecs: wcd-common=
: fix signedness bug in wcd_dt_parse_micbias_info()
# good: [4e65bda8273c938039403144730923e77916a3d7] ASoC: wcd934x: fix error=
 handling in wcd934x_codec_parse_data()
# good: [ef104054a312608deab266f95945057fa73eeaad] powerpc/pseries: Define =
__u{8,32} types in papr_hvpipe_hdr struct
# good: [e609438851928381e39b5393f17156955a84122a] regulator: dt-bindings: =
qcom,sdm845-refgen-regulator: document more platforms
# good: [5fa7d739f811bdffb5fc99696c2e821344fe0b88] regulator: dt-bindings: =
qcom,sdm845-refgen-regulator: document more platforms
# good: [878702702dbbd933a5da601c75b8e58eadeec311] spi: ljca: Remove Wenton=
g's e-mail address
# good: [2de8b6dd5ae72eb6fb7c756a3f2c131171fe3b8b] powerpc/perf/vpa-dtl: Ad=
d support to capture DTL data in aux buffer
# good: [ad4728740bd68d74365a43acc25a65339a9b2173] spi: rpc-if: Add resume =
support for RZ/G3E
# good: [63b4c34635cf32af023796b64c855dd1ed0f0a4f] tas2783A: Add acpi match=
 changes for Intel MTL
# good: [f98cabe3f6cf6396b3ae0264800d9b53d7612433] SPI: Add virtio SPI driv=
er
# good: [46c8b4d2a693eca69a2191436cffa44f489e98c7] ASoC: cs35l41: Fallback =
to reading Subsystem ID property if not ACPI
# good: [9d52b0b41be5b932a0a929c10038f1bb04af4ca5] xen: take system_transit=
ion_mutex on suspend
# good: [e336ab509b43ea601801dfa05b4270023c3ed007] spi: rename SPI_CS_CNT_M=
AX =3D> SPI_DEVICE_CS_CNT_MAX
# good: [87cab86925b7fa4c1c977bc191ac549a3b23f0ea] ASoC: Intel: sof_sdw: Pr=
event jump to NULL add_sidecar callback
# good: [a24802b0a2a238eaa610b0b0e87a4500a35de64a] spi: spi-qpic-snand: sim=
plify clock handling by using devm_clk_get_enabled()
# good: [20253f806818e9a1657a832ebcf4141d0a08c02a] spi: atmel-quadspi: Add =
support for sama7d65 QSPI
# good: [0f67557763accbdd56681f17ed5350735198c57b] spi: spi-nxp-fspi: Add O=
CT-DTR mode support
# good: [0266f9541038b9b98ddd387132b5bdfe32a304e3] ASoC: codecs: wcd937x: g=
et regmap directly
# good: [2aa28b748fc967a2f2566c06bdad155fba8af7d8] ASoC: da7213: Convert to=
 DEFINE_RUNTIME_DEV_PM_OPS()
# good: [2c618f361ae6b9da7fafafc289051728ef4c6ea3] ASoC: fsl: fsl_qmc_audio=
: Drop struct qmc_dai_chan
# good: [cb3c715d89607f8896c0f20fe528a08e7ebffea9] ASoC: soc-dapm: add snd_=
soc_dapm_set_idle_bias()
# good: [62a7b3bbb6b873fdcc85a37efbd0102d66c8a73e] ASoC: SOF: ipc4-pcm: Fix=
 incorrect comparison with number of tdm_slots
# good: [abe962346ef420998d47ba1c2fe591582f69e92e] regulator: Fix MAX77838 =
selection
# good: [ab63e9910d2d3ea4b8e6c08812258a676defcb9c] spi: mt65xx: add dual an=
d quad mode for standard spi device
# good: [88d0d17192c5a850dc07bb38035b69c4cefde270] ASoC: dt-bindings: add b=
indings for pm4125 audio codec
# good: [8b84d712ad849172f6bbcad57534b284d942b0b5] regulator: spacemit: sup=
port SpacemiT P1 regulators
# good: [8d7de4a014f589c1776959f7fdadbf7b12045aac] ASoC: dt-bindings: asahi=
-kasei,ak4458: Reference common DAI properties
# good: [6a1f303cba45fa3b612d5a2898b1b1b045eb74e3] regulator: max77838: add=
 max77838 regulator driver
# good: [8b184c34806e5da4d4847fabd3faeff38b47e70a] ASoC: Intel: hda-sdw-bpt=
: set persistent_buffer false
# good: [18dda9eb9e11b2aeec73cbe2a56ab2f862841ba4] spi: amlogic: Fix error =
checking on regmap_write call
# good: [b48b6cc8c655d8cdcf5124ba9901b74c8f759668] powerpc/pseries: Enable =
HVPIPE event message interrupt
# good: [30db1b21fa37a2f37c7f4d71864405a05e889833] spi: axi-spi-engine: use=
 adi_axi_pcore_ver_gteq()
# good: [59ba108806516adeaed51a536d55d4f5e9645881] ASoC: dt-bindings: linux=
,spdif: Add "port" node
# good: [1217b573978482ae7d21dc5c0bf5aa5007b24f90] ASoC: codecs: pcm1754: a=
dd pcm1754 dac driver
# good: [2e0fd4583d0efcdc260e61a22666c8368f505353] rust: regulator: add dev=
m_enable and devm_enable_optional
# good: [d9e33b38c89f4cf8c32b8481dbcf3a6cdbba4595] spi: cadence-quadspi: Us=
e BIT() macros where possible
# good: [e5b4ad2183f7ab18aaf7c73a120d17241ee58e97] ASoC: cs-amp-lib-test: A=
dd test for getting cal data from HP EFI
# good: [3fcc8e146935415d69ffabb5df40ecf50e106131] xen/events: Update virq_=
to_irq on migration
# good: [4336efb59ef364e691ef829a73d9dbd4d5ed7c7b] ASoC: Intel: bytcr_rt565=
1: Fix invalid quirk input mapping
# good: [5bad16482c2a7e788c042d98f3e97d3b2bbc8cc5] regulator: dt-bindings: =
rpi-panel: Split 7" Raspberry Pi 720x1280 v2 binding
# good: [1cf87861a2e02432fb68f8bcc8f20a8e42acde59] ASoC: codecs: tlv320dac3=
3: Convert to use gpiod api
# good: [7d083666123a425ba9f81dff1a52955b1f226540] ASoC: renesas: rz-ssi: U=
se guard() for spin locks
# good: [2c625f0fe2db4e6a58877ce2318df3aa312eb791] spi: dt-bindings: samsun=
g: Drop S3C2443
# good: [b497e1a1a2b10c4ddb28064fba229365ae03311a] regulator: pf530x: Add a=
 driver for the NXP PF5300 Regulator
# good: [9e5eb8b49ffe3c173bf7b8c338a57dfa09fb4634] ASoC: replace use of sys=
tem_unbound_wq with system_dfl_wq
# good: [0ccc1eeda155c947d88ef053e0b54e434e218ee2] ASoC: dt-bindings: wlf,w=
m8960: Document routing strings (pin names)
# good: [7748328c2fd82efed24257b2bfd796eb1fa1d09b] ASoC: dt-bindings: qcom,=
lpass-va-macro: Update bindings for clocks to support ADSP
# good: [dd7ae5b8b3c291c0206f127a564ae1e316705ca0] ASoC: cs42l43: Shutdown =
jack detection on suspend
# good: [ce57b718006a069226b5e5d3afe7969acd59154e] ASoC: Intel: avs: ssm456=
7: Adjust platform name
# good: [5cc49b5a36b32a2dba41441ea13b93fb5ea21cfd] spi: spi-fsl-dspi: Repor=
t FIFO overflows as errors
# good: [94b39cb3ad6db935b585988b36378884199cd5fc] spi: mxs: fix "transfere=
d"->"transferred"
# good: [ce1a46b2d6a8465a86f7a6f71beb4c6de83bce5c] ASoC: codecs: lpass-wsa-=
macro: add Codev version 2.9
# good: [3279052eab235bfb7130b1fabc74029c2260ed8d] ASoC: SOF: ipc4-topology=
: Fix a less than zero check on a u32
# good: [9d35d068fb138160709e04e3ee97fe29a6f8615b] regulator: scmi: Use int=
 type to store negative error codes
# good: [8f57dcf39fd0864f5f3e6701fe885e55f45d0d3a] ASoC: qcom: audioreach: =
convert to cpu endainess type before accessing
# good: [8a9772ec08f87c9e45ab1ad2c8d2b8c1763836eb] ASoC: soc-dapm: rename s=
nd_soc_kcontrol_component() to snd_soc_kcontrol_to_component()
# good: [3d439e1ec3368fae17db379354bd7a9e568ca0ab] ASoC: sof: ipc4-topology=
: Add support to sched_domain attribute
# good: [d57d27171c92e9049d5301785fb38de127b28fbf] ASoC: SOF: sof-client-pr=
obes: Add available points_info(), IPC4 only
# good: [f7c41911ad744177d8289820f01009dc93d8f91c] ASoC: SOF: ipc4-topology=
: Add support for float sample type
# good: [07752abfa5dbf7cb4d9ce69fa94dc3b12bc597d9] ASoC: SOF: sof-client: I=
ntroduce sof_client_dev_entry structure
# good: [f522da9ab56c96db8703b2ea0f09be7cdc3bffeb] ASoC: doc: Internally li=
nk to Writing an ALSA Driver docs
# good: [5c39bc498f5ff7ef016abf3f16698f3e8db79677] ASoC: SOF: Intel: only d=
etect codecs when HDA DSP probe
# good: [f4672dc6e9c07643c8c755856ba8e9eb9ca95d0c] regmap: use int type to =
store negative error codes
# good: [ff9a7857b7848227788f113d6dc6a72e989084e0] spi: rb4xx: use devm for=
 clk_prepare_enable
# good: [edb5c1f885207d1d74e8a1528e6937e02829ee6e] ASoC: renesas: msiof: st=
art DMAC first
# good: [b088b6189a4066b97cef459afd312fd168a76dea] ASoC: mediatek: common: =
Switch to for_each_available_child_of_node_scoped()
# good: [a37280daa4d583c7212681c49b285de9464a5200] ASoC: Intel: avs: Allow =
i2s test and non-test boards to coexist
# good: [899fb38dd76dd3ede425bbaf8a96d390180a5d1c] regulator: core: Remove =
redundant ternary operators
# good: [e2ab5f600bb01d3625d667d97b3eb7538e388336] rust: regulator: use `to=
_result` for error handling
# good: [11f5c5f9e43e9020bae452232983fe98e7abfce0] ASoC: qcom: use int type=
 to store negative error codes
# good: [5b4dcaf851df8c414bfc2ac3bf9c65fc942f3be4] ASoC: amd: acp: Remove (=
explicitly) unused header
# good: [c42e36a488c7e01f833fc9f4814f735b66b2d494] spi: Drop dev_pm_domain_=
detach() call
# good: [a12b74d2bd4724ee1883bc97ec93eac8fafc8d3c] ASoC: tlv320aic32x4: use=
 dev_err_probe() for regulators
# good: [f840737d1746398c2993be34bfdc80bdc19ecae2] ASoC: SOF: imx: Remove t=
he use of dev_err_probe()
# good: [d78e48ebe04e9566f8ecbf51471e80da3adbceeb] ASoC: dt-bindings: Minor=
 whitespace cleanup in example
# good: [c232495d28ca092d0c39b10e35d3d613bd2414ab] ASoC: dt-bindings: omap-=
twl4030: convert to DT schema
# good: [96bcb34df55f7fee99795127c796315950c94fed] ASoC: test-component: Us=
e kcalloc() instead of kzalloc()
# good: [ec0be3cdf40b5302248f3fb27a911cc630e8b855] regulator: consumer.rst:=
 document bulk operations
# good: [41f6710f99f4337924e3929e8e7a51c74f800b91] KVM: x86: Manually clear=
 MPX state only on INIT
# good: [da9881d00153cc6d3917f6b74144b1d41b58338c] ASoC: qcom: audioreach: =
add support for SMECNS module
# good: [c1dd310f1d76b4b13f1854618087af2513140897] spi: SPISG: Use devm_kca=
lloc() in aml_spisg_clk_init()
# good: [27848c082ba0b22850fd9fb7b185c015423dcdc7] spi: s3c64xx: Remove the=
 use of dev_err_probe()
# good: [90179609efa421b1ccc7d8eafbc078bafb25777c] spi: spl022: use min_t()=
 to improve code
# good: [2a55135201d5e24b80b7624880ff42eafd8e320c] ASoC: Intel: avs: Stream=
line register-component function names
# good: [550bc517e59347b3b1af7d290eac4fb1411a3d4e] regulator: bd718x7: Use =
kcalloc() instead of kzalloc()
# good: [0056b410355713556d8a10306f82e55b28d33ba8] spi: offload trigger: ad=
i-util-sigma-delta: clean up imports
# good: [cf65182247761f7993737b710afe8c781699356b] ASoC: codecs: wsa883x: H=
andle shared reset GPIO for WSA883x speakers
# good: [daf855f76a1210ceed9541f71ac5dd9be02018a6] ASoC: es8323: enable DAP=
M power widgets for playback DAC
# good: [6d068f1ae2a2f713d7f21a9a602e65b3d6b6fc6d] regulator: rt5133: Fix s=
pelling mistake "regualtor" -> "regulator"
# good: [258384d8ce365dddd6c5c15204de8ccd53a7ab0a] ASoC: es8323: enable DAP=
M power widgets for playback DAC and output
# good: [a46e95c81e3a28926ab1904d9f754fef8318074d] ASoC: wl1273: Remove
# good: [0e62438e476494a1891a8822b9785bc6e73e9c3f] ASoC: Intel: sst: Remove=
 redundant semicolons
# good: [48124569bbc6bfda1df3e9ee17b19d559f4b1aa3] spi: remove unneeded 'fa=
st_io' parameter in regmap_config
# good: [37533933bfe92cd5a99ef4743f31dac62ccc8de0] regulator: remove unneed=
ed 'fast_io' parameter in regmap_config
# good: [5c36b86d2bf68fbcad16169983ef7ee8c537db59] regmap: Remove superfluo=
us check for !config in __regmap_init()
# good: [714165e1c4b0d5b8c6d095fe07f65e6e7047aaeb] regulator: rt5133: Add R=
T5133 PMIC regulator Support
# good: [9c45f95222beecd6a284fd1284d54dd7a772cf59] spi: spi-qpic-snand: han=
dle 'use_ecc' parameter of qcom_spi_config_cw_read()
# good: [bab4ab484a6ca170847da9bffe86f1fa90df4bbe] ASoC: dt-bindings: Conve=
rt brcm,bcm2835-i2s to DT schema
# good: [b832b19318534bb4f1673b24d78037fee339c679] spi: loopback-test: Don'=
t use %pK through printk
# good: [8c02c8353460f8630313aef6810f34e134a3c1ee] ASoC: dt-bindings: realt=
ek,alc5623: convert to DT schema
# good: [6b7e2aa50bdaf88cd4c2a5e2059a7bf32d85a8b1] spi: spi-qpic-snand: rem=
ove 'clr*status' members of struct 'qpic_ecc'
# good: [a54ef14188519a0994d0264f701f5771815fa11e] regulator: dt-bindings: =
Clean-up active-semi,act8945a duplication
# good: [2291a2186305faaf8525d57849d8ba12ad63f5e7] MAINTAINERS: Add entry f=
or FourSemi audio amplifiers
# good: [886f42ce96e7ce80545704e7168a9c6b60cd6c03] regmap: mmio: Add missin=
g MODULE_DESCRIPTION()
# good: [162e23657e5379f07c6404dbfbf4367cb438ea7d] regulator: pf0900: Add P=
MIC PF0900 support
# good: [a1d0b0ae65ae3f32597edfbb547f16c75601cd87] spi: spi-qpic-snand: avo=
id double assignment in qcom_spi_probe()
# good: [595b7f155b926460a00776cc581e4dcd01220006] ASoC: Intel: avs: Condit=
ional-path support
# good: [cf25eb8eae91bcae9b2065d84b0c0ba0f6d9dd34] ASoC: soc-component: unp=
ack snd_soc_component_init_bias_level()
# good: [3059067fd3378a5454e7928c08d20bf3ef186760] ASoC: cs48l32: Use PTR_E=
RR_OR_ZERO() to simplify code
# good: [9a200cbdb54349909a42b45379e792e4b39dd223] rust: regulator: impleme=
nt Send and Sync for Regulator<T>
# good: [2d86d2585ab929a143d1e6f8963da1499e33bf13] ASoC: pxa: add GPIOLIB_L=
EGACY dependency
git bisect start '211ddde0823f1442e4ad052a2f30f050145ccada' 'e5f0a698b34ed7=
6002dc5cff3804a61c80233a7a' '5a6f65d1502551f84c158789e5d89299c78907c7' 'f40=
6055cb18c6e299c4a783fc1effeb16be41803' '5726b68473f7153a7f6294185e5998b7e2a=
230a2' '7ea30958b3054f5e488fa0b33c352723f7ab3a2a' '98ac9cc4b4452ed7e714eddc=
8c90ac4ae5da1a09' '6f3b6e91f7201e248d83232538db14d30100e9c7' '9b332cece987e=
e1790b2ed4c989e28162fa47860' '1f4a222b0e334540343fbb5d3eac4584a6bfe180' 'd5=
cda96d0130effd4255f7c5e720a58760a032a4' '6370a996f308ea3276030769b7482b346e=
7cc7c1' 'ee70bacef1c6050e4836409927294d744dbcfa72' 'dee4ef0ebe4dee655657ead=
30892aeca16462823' '3a8660878839faadb4f1a6dd72c3179c1df56787' '0739473694c4=
878513031006829f1030ec850bc2' '8765f467912ff0d4832eeaf26ae573792da877e7' '6=
7029a49db6c1f21106a1b5fcdd0ea234a6e0711' '98906f9d850e4882004749eccb8920649=
dc98456' '8bd9238e511d02831022ff0270865c54ccc482d6' '9591fdb0611dccdeeeeacb=
99d89f0098737d209b' 'cd5a0afbdf8033dc83786315d63f8b325bdba2fd' 'ec714e371f2=
2f716a04e6ecb2a24988c92b26911' '5472d60c129f75282d94ae5ad072ee6dfb7c7246' '=
0d97f2067c166eb495771fede9f7b73999c67f66' '18a7e218cfcdca6666e1f7356533e4c9=
88780b57' 'a8cdf51cda30f7461a98af821e8a28c5cb5f8878' 'a27539810e1e61efcfdeb=
51777ed875dc61e9d49' 'c746c3b5169831d7fb032a1051d8b45592ae8d78' '56019d4ff8=
dd5ef16915c2605988c4022a46019c' '6a74422b9710e987c7d6b85a1ade7330b1e61626' =
'd104e3d17f7bfc505281f57f8c1a5589fca6ffe4' '6093a688a07da07808f0122f9aa2a3e=
ed250d853' 'b41048485ee395edbbb69fc83491d314268f7bdb' 'ba9dac987319d4f39696=
91dcf366ef19c9ed8281' '7a405dbb0f036f8d1713ab9e7df0cd3137987b07' 'fd94619c4=
3360eb44d28bd3ef326a4f85c600a07' 'cbf33b8e0b360f667b17106c15d9e2aac77a76a1'=
 'aaab61de1f1e44a2ab527e935474e2e03a0f6b08' 'd3479214c05dbd07bc56f8823e7bd8=
719fcd39a9' 'bace10b59624e6bd8d68bc9304357f292f1b3dcf' '45ad27d9a6f7c620d8b=
bc80be3bab1faf37dfa0a' '080ffb4bec4d49cdedca11810395f8cad812471e' 'd5f74114=
114cb2cdbed75b91ca2fa4482c1d5611' '50c19e20ed2ef359cf155a39c8462b0a6351b9fa=
' '4b81e2eb9e4db8f6094c077d0c8b27c264901c1b' '22bdd6e68bbe270a916233ec5f34a=
13ae5e80ed9' '417552999d0b6681ac30e117ae890828ca7e46b3' '9cc220a422113f665e=
13364be1411c7bba9e3e30' '755fa5b4fb36627796af19932a432d343220ec63' '30d4efb=
2f5a515a60fe6b0ca85362cbebea21e2f' 'feafee284579d29537a5a56ba8f23894f0463f3=
d' '449c2b302c8e200558619821ced46cc13cdb9aa6' '1896ce8eb6c61824f6c1125d69d8=
fda1f44a22f8' '733a763dd8b3ac2858dd238a91bb3a2fdff4739e' 'f8b9c819ea20d1101=
656a91ced843d9e47ba0630' 'e26387e950ee4486b4ed5728b5d3c1430c33ba67' '6be988=
660b474564c77cb6ff60776dafcd850a18' '82fd5dc99d63f948c59ac3b08137ef49125938=
bc' 'dc64b3d42cb361d4b39eb7cc73037fec52ef9676' '4e65bda8273c938039403144730=
923e77916a3d7' 'ef104054a312608deab266f95945057fa73eeaad' 'e609438851928381=
e39b5393f17156955a84122a' '5fa7d739f811bdffb5fc99696c2e821344fe0b88' '87870=
2702dbbd933a5da601c75b8e58eadeec311' '2de8b6dd5ae72eb6fb7c756a3f2c131171fe3=
b8b' 'ad4728740bd68d74365a43acc25a65339a9b2173' '63b4c34635cf32af023796b64c=
855dd1ed0f0a4f' 'f98cabe3f6cf6396b3ae0264800d9b53d7612433' '46c8b4d2a693eca=
69a2191436cffa44f489e98c7' '9d52b0b41be5b932a0a929c10038f1bb04af4ca5' 'e336=
ab509b43ea601801dfa05b4270023c3ed007' '87cab86925b7fa4c1c977bc191ac549a3b23=
f0ea' 'a24802b0a2a238eaa610b0b0e87a4500a35de64a' '20253f806818e9a1657a832eb=
cf4141d0a08c02a' '0f67557763accbdd56681f17ed5350735198c57b' '0266f9541038b9=
b98ddd387132b5bdfe32a304e3' '2aa28b748fc967a2f2566c06bdad155fba8af7d8' '2c6=
18f361ae6b9da7fafafc289051728ef4c6ea3' 'cb3c715d89607f8896c0f20fe528a08e7eb=
ffea9' '62a7b3bbb6b873fdcc85a37efbd0102d66c8a73e' 'abe962346ef420998d47ba1c=
2fe591582f69e92e' 'ab63e9910d2d3ea4b8e6c08812258a676defcb9c' '88d0d17192c5a=
850dc07bb38035b69c4cefde270' '8b84d712ad849172f6bbcad57534b284d942b0b5' '8d=
7de4a014f589c1776959f7fdadbf7b12045aac' '6a1f303cba45fa3b612d5a2898b1b1b045=
eb74e3' '8b184c34806e5da4d4847fabd3faeff38b47e70a' '18dda9eb9e11b2aeec73cbe=
2a56ab2f862841ba4' 'b48b6cc8c655d8cdcf5124ba9901b74c8f759668' '30db1b21fa37=
a2f37c7f4d71864405a05e889833' '59ba108806516adeaed51a536d55d4f5e9645881' '1=
217b573978482ae7d21dc5c0bf5aa5007b24f90' '2e0fd4583d0efcdc260e61a22666c8368=
f505353' 'd9e33b38c89f4cf8c32b8481dbcf3a6cdbba4595' 'e5b4ad2183f7ab18aaf7c7=
3a120d17241ee58e97' '3fcc8e146935415d69ffabb5df40ecf50e106131' '4336efb59ef=
364e691ef829a73d9dbd4d5ed7c7b' '5bad16482c2a7e788c042d98f3e97d3b2bbc8cc5' '=
1cf87861a2e02432fb68f8bcc8f20a8e42acde59' '7d083666123a425ba9f81dff1a52955b=
1f226540' '2c625f0fe2db4e6a58877ce2318df3aa312eb791' 'b497e1a1a2b10c4ddb280=
64fba229365ae03311a' '9e5eb8b49ffe3c173bf7b8c338a57dfa09fb4634' '0ccc1eeda1=
55c947d88ef053e0b54e434e218ee2' '7748328c2fd82efed24257b2bfd796eb1fa1d09b' =
'dd7ae5b8b3c291c0206f127a564ae1e316705ca0' 'ce57b718006a069226b5e5d3afe7969=
acd59154e' '5cc49b5a36b32a2dba41441ea13b93fb5ea21cfd' '94b39cb3ad6db935b585=
988b36378884199cd5fc' 'ce1a46b2d6a8465a86f7a6f71beb4c6de83bce5c' '3279052ea=
b235bfb7130b1fabc74029c2260ed8d' '9d35d068fb138160709e04e3ee97fe29a6f8615b'=
 '8f57dcf39fd0864f5f3e6701fe885e55f45d0d3a' '8a9772ec08f87c9e45ab1ad2c8d2b8=
c1763836eb' '3d439e1ec3368fae17db379354bd7a9e568ca0ab' 'd57d27171c92e9049d5=
301785fb38de127b28fbf' 'f7c41911ad744177d8289820f01009dc93d8f91c' '07752abf=
a5dbf7cb4d9ce69fa94dc3b12bc597d9' 'f522da9ab56c96db8703b2ea0f09be7cdc3bffeb=
' '5c39bc498f5ff7ef016abf3f16698f3e8db79677' 'f4672dc6e9c07643c8c755856ba8e=
9eb9ca95d0c' 'ff9a7857b7848227788f113d6dc6a72e989084e0' 'edb5c1f885207d1d74=
e8a1528e6937e02829ee6e' 'b088b6189a4066b97cef459afd312fd168a76dea' 'a37280d=
aa4d583c7212681c49b285de9464a5200' '899fb38dd76dd3ede425bbaf8a96d390180a5d1=
c' 'e2ab5f600bb01d3625d667d97b3eb7538e388336' '11f5c5f9e43e9020bae452232983=
fe98e7abfce0' '5b4dcaf851df8c414bfc2ac3bf9c65fc942f3be4' 'c42e36a488c7e01f8=
33fc9f4814f735b66b2d494' 'a12b74d2bd4724ee1883bc97ec93eac8fafc8d3c' 'f84073=
7d1746398c2993be34bfdc80bdc19ecae2' 'd78e48ebe04e9566f8ecbf51471e80da3adbce=
eb' 'c232495d28ca092d0c39b10e35d3d613bd2414ab' '96bcb34df55f7fee99795127c79=
6315950c94fed' 'ec0be3cdf40b5302248f3fb27a911cc630e8b855' '41f6710f99f43379=
24e3929e8e7a51c74f800b91' 'da9881d00153cc6d3917f6b74144b1d41b58338c' 'c1dd3=
10f1d76b4b13f1854618087af2513140897' '27848c082ba0b22850fd9fb7b185c015423dc=
dc7' '90179609efa421b1ccc7d8eafbc078bafb25777c' '2a55135201d5e24b80b7624880=
ff42eafd8e320c' '550bc517e59347b3b1af7d290eac4fb1411a3d4e' '0056b4103557135=
56d8a10306f82e55b28d33ba8' 'cf65182247761f7993737b710afe8c781699356b' 'daf8=
55f76a1210ceed9541f71ac5dd9be02018a6' '6d068f1ae2a2f713d7f21a9a602e65b3d6b6=
fc6d' '258384d8ce365dddd6c5c15204de8ccd53a7ab0a' 'a46e95c81e3a28926ab1904d9=
f754fef8318074d' '0e62438e476494a1891a8822b9785bc6e73e9c3f' '48124569bbc6bf=
da1df3e9ee17b19d559f4b1aa3' '37533933bfe92cd5a99ef4743f31dac62ccc8de0' '5c3=
6b86d2bf68fbcad16169983ef7ee8c537db59' '714165e1c4b0d5b8c6d095fe07f65e6e704=
7aaeb' '9c45f95222beecd6a284fd1284d54dd7a772cf59' 'bab4ab484a6ca170847da9bf=
fe86f1fa90df4bbe' 'b832b19318534bb4f1673b24d78037fee339c679' '8c02c8353460f=
8630313aef6810f34e134a3c1ee' '6b7e2aa50bdaf88cd4c2a5e2059a7bf32d85a8b1' 'a5=
4ef14188519a0994d0264f701f5771815fa11e' '2291a2186305faaf8525d57849d8ba12ad=
63f5e7' '886f42ce96e7ce80545704e7168a9c6b60cd6c03' '162e23657e5379f07c6404d=
bfbf4367cb438ea7d' 'a1d0b0ae65ae3f32597edfbb547f16c75601cd87' '595b7f155b92=
6460a00776cc581e4dcd01220006' 'cf25eb8eae91bcae9b2065d84b0c0ba0f6d9dd34' '3=
059067fd3378a5454e7928c08d20bf3ef186760' '9a200cbdb54349909a42b45379e792e4b=
39dd223' '2d86d2585ab929a143d1e6f8963da1499e33bf13'
# test job: [5a6f65d1502551f84c158789e5d89299c78907c7] https://lava.sirena.=
org.uk/scheduler/job/1959657
# test job: [f406055cb18c6e299c4a783fc1effeb16be41803] https://lava.sirena.=
org.uk/scheduler/job/1967099
# test job: [5726b68473f7153a7f6294185e5998b7e2a230a2] https://lava.sirena.=
org.uk/scheduler/job/1959580
# test job: [7ea30958b3054f5e488fa0b33c352723f7ab3a2a] https://lava.sirena.=
org.uk/scheduler/job/1960916
# test job: [98ac9cc4b4452ed7e714eddc8c90ac4ae5da1a09] https://lava.sirena.=
org.uk/scheduler/job/1963385
# test job: [6f3b6e91f7201e248d83232538db14d30100e9c7] https://lava.sirena.=
org.uk/scheduler/job/1965548
# test job: [9b332cece987ee1790b2ed4c989e28162fa47860] https://lava.sirena.=
org.uk/scheduler/job/1956021
# test job: [1f4a222b0e334540343fbb5d3eac4584a6bfe180] https://lava.sirena.=
org.uk/scheduler/job/1959236
# test job: [d5cda96d0130effd4255f7c5e720a58760a032a4] https://lava.sirena.=
org.uk/scheduler/job/1957517
# test job: [6370a996f308ea3276030769b7482b346e7cc7c1] https://lava.sirena.=
org.uk/scheduler/job/1946187
# test job: [ee70bacef1c6050e4836409927294d744dbcfa72] https://lava.sirena.=
org.uk/scheduler/job/1948110
# test job: [dee4ef0ebe4dee655657ead30892aeca16462823] https://lava.sirena.=
org.uk/scheduler/job/1946074
# test job: [3a8660878839faadb4f1a6dd72c3179c1df56787] https://lava.sirena.=
org.uk/scheduler/job/1944005
# test job: [0739473694c4878513031006829f1030ec850bc2] https://lava.sirena.=
org.uk/scheduler/job/1939889
# test job: [8765f467912ff0d4832eeaf26ae573792da877e7] https://lava.sirena.=
org.uk/scheduler/job/1942896
# test job: [67029a49db6c1f21106a1b5fcdd0ea234a6e0711] https://lava.sirena.=
org.uk/scheduler/job/1941767
# test job: [98906f9d850e4882004749eccb8920649dc98456] https://lava.sirena.=
org.uk/scheduler/job/1941468
# test job: [8bd9238e511d02831022ff0270865c54ccc482d6] https://lava.sirena.=
org.uk/scheduler/job/1939529
# test job: [9591fdb0611dccdeeeeacb99d89f0098737d209b] https://lava.sirena.=
org.uk/scheduler/job/1941207
# test job: [cd5a0afbdf8033dc83786315d63f8b325bdba2fd] https://lava.sirena.=
org.uk/scheduler/job/1934636
# test job: [ec714e371f22f716a04e6ecb2a24988c92b26911] https://lava.sirena.=
org.uk/scheduler/job/1935591
# test job: [5472d60c129f75282d94ae5ad072ee6dfb7c7246] https://lava.sirena.=
org.uk/scheduler/job/1937073
# test job: [0d97f2067c166eb495771fede9f7b73999c67f66] https://lava.sirena.=
org.uk/scheduler/job/1932818
# test job: [18a7e218cfcdca6666e1f7356533e4c988780b57] https://lava.sirena.=
org.uk/scheduler/job/1936870
# test job: [a8cdf51cda30f7461a98af821e8a28c5cb5f8878] https://lava.sirena.=
org.uk/scheduler/job/1932365
# test job: [a27539810e1e61efcfdeb51777ed875dc61e9d49] https://lava.sirena.=
org.uk/scheduler/job/1930595
# test job: [c746c3b5169831d7fb032a1051d8b45592ae8d78] https://lava.sirena.=
org.uk/scheduler/job/1929171
# test job: [56019d4ff8dd5ef16915c2605988c4022a46019c] https://lava.sirena.=
org.uk/scheduler/job/1931753
# test job: [6a74422b9710e987c7d6b85a1ade7330b1e61626] https://lava.sirena.=
org.uk/scheduler/job/1925134
# test job: [d104e3d17f7bfc505281f57f8c1a5589fca6ffe4] https://lava.sirena.=
org.uk/scheduler/job/1923376
# test job: [6093a688a07da07808f0122f9aa2a3eed250d853] https://lava.sirena.=
org.uk/scheduler/job/1924001
# test job: [b41048485ee395edbbb69fc83491d314268f7bdb] https://lava.sirena.=
org.uk/scheduler/job/1922961
# test job: [ba9dac987319d4f3969691dcf366ef19c9ed8281] https://lava.sirena.=
org.uk/scheduler/job/1928665
# test job: [7a405dbb0f036f8d1713ab9e7df0cd3137987b07] https://lava.sirena.=
org.uk/scheduler/job/1925596
# test job: [fd94619c43360eb44d28bd3ef326a4f85c600a07] https://lava.sirena.=
org.uk/scheduler/job/1926303
# test job: [cbf33b8e0b360f667b17106c15d9e2aac77a76a1] https://lava.sirena.=
org.uk/scheduler/job/1921710
# test job: [aaab61de1f1e44a2ab527e935474e2e03a0f6b08] https://lava.sirena.=
org.uk/scheduler/job/1916352
# test job: [d3479214c05dbd07bc56f8823e7bd8719fcd39a9] https://lava.sirena.=
org.uk/scheduler/job/1910098
# test job: [bace10b59624e6bd8d68bc9304357f292f1b3dcf] https://lava.sirena.=
org.uk/scheduler/job/1911692
# test job: [45ad27d9a6f7c620d8bbc80be3bab1faf37dfa0a] https://lava.sirena.=
org.uk/scheduler/job/1912547
# test job: [080ffb4bec4d49cdedca11810395f8cad812471e] https://lava.sirena.=
org.uk/scheduler/job/1910581
# test job: [d5f74114114cb2cdbed75b91ca2fa4482c1d5611] https://lava.sirena.=
org.uk/scheduler/job/1909537
# test job: [50c19e20ed2ef359cf155a39c8462b0a6351b9fa] https://lava.sirena.=
org.uk/scheduler/job/1908257
# test job: [4b81e2eb9e4db8f6094c077d0c8b27c264901c1b] https://lava.sirena.=
org.uk/scheduler/job/1907396
# test job: [22bdd6e68bbe270a916233ec5f34a13ae5e80ed9] https://lava.sirena.=
org.uk/scheduler/job/1906808
# test job: [417552999d0b6681ac30e117ae890828ca7e46b3] https://lava.sirena.=
org.uk/scheduler/job/1903320
# test job: [9cc220a422113f665e13364be1411c7bba9e3e30] https://lava.sirena.=
org.uk/scheduler/job/1903006
# test job: [755fa5b4fb36627796af19932a432d343220ec63] https://lava.sirena.=
org.uk/scheduler/job/1906245
# test job: [30d4efb2f5a515a60fe6b0ca85362cbebea21e2f] https://lava.sirena.=
org.uk/scheduler/job/1902765
# test job: [feafee284579d29537a5a56ba8f23894f0463f3d] https://lava.sirena.=
org.uk/scheduler/job/1902899
# test job: [449c2b302c8e200558619821ced46cc13cdb9aa6] https://lava.sirena.=
org.uk/scheduler/job/1900789
# test job: [1896ce8eb6c61824f6c1125d69d8fda1f44a22f8] https://lava.sirena.=
org.uk/scheduler/job/1901763
# test job: [733a763dd8b3ac2858dd238a91bb3a2fdff4739e] https://lava.sirena.=
org.uk/scheduler/job/1889809
# test job: [f8b9c819ea20d1101656a91ced843d9e47ba0630] https://lava.sirena.=
org.uk/scheduler/job/1890771
# test job: [e26387e950ee4486b4ed5728b5d3c1430c33ba67] https://lava.sirena.=
org.uk/scheduler/job/1888633
# test job: [6be988660b474564c77cb6ff60776dafcd850a18] https://lava.sirena.=
org.uk/scheduler/job/1879955
# test job: [82fd5dc99d63f948c59ac3b08137ef49125938bc] https://lava.sirena.=
org.uk/scheduler/job/1880565
# test job: [dc64b3d42cb361d4b39eb7cc73037fec52ef9676] https://lava.sirena.=
org.uk/scheduler/job/1881538
# test job: [4e65bda8273c938039403144730923e77916a3d7] https://lava.sirena.=
org.uk/scheduler/job/1868113
# test job: [ef104054a312608deab266f95945057fa73eeaad] https://lava.sirena.=
org.uk/scheduler/job/1903213
# test job: [e609438851928381e39b5393f17156955a84122a] https://lava.sirena.=
org.uk/scheduler/job/1868349
# test job: [5fa7d739f811bdffb5fc99696c2e821344fe0b88] https://lava.sirena.=
org.uk/scheduler/job/1868328
# test job: [878702702dbbd933a5da601c75b8e58eadeec311] https://lava.sirena.=
org.uk/scheduler/job/1863731
# test job: [2de8b6dd5ae72eb6fb7c756a3f2c131171fe3b8b] https://lava.sirena.=
org.uk/scheduler/job/1903086
# test job: [ad4728740bd68d74365a43acc25a65339a9b2173] https://lava.sirena.=
org.uk/scheduler/job/1862562
# test job: [63b4c34635cf32af023796b64c855dd1ed0f0a4f] https://lava.sirena.=
org.uk/scheduler/job/1863511
# test job: [f98cabe3f6cf6396b3ae0264800d9b53d7612433] https://lava.sirena.=
org.uk/scheduler/job/1862322
# test job: [46c8b4d2a693eca69a2191436cffa44f489e98c7] https://lava.sirena.=
org.uk/scheduler/job/1862086
# test job: [9d52b0b41be5b932a0a929c10038f1bb04af4ca5] https://lava.sirena.=
org.uk/scheduler/job/1903273
# test job: [e336ab509b43ea601801dfa05b4270023c3ed007] https://lava.sirena.=
org.uk/scheduler/job/1862843
# test job: [87cab86925b7fa4c1c977bc191ac549a3b23f0ea] https://lava.sirena.=
org.uk/scheduler/job/1850922
# test job: [a24802b0a2a238eaa610b0b0e87a4500a35de64a] https://lava.sirena.=
org.uk/scheduler/job/1847654
# test job: [20253f806818e9a1657a832ebcf4141d0a08c02a] https://lava.sirena.=
org.uk/scheduler/job/1848491
# test job: [0f67557763accbdd56681f17ed5350735198c57b] https://lava.sirena.=
org.uk/scheduler/job/1848701
# test job: [0266f9541038b9b98ddd387132b5bdfe32a304e3] https://lava.sirena.=
org.uk/scheduler/job/1848813
# test job: [2aa28b748fc967a2f2566c06bdad155fba8af7d8] https://lava.sirena.=
org.uk/scheduler/job/1850320
# test job: [2c618f361ae6b9da7fafafc289051728ef4c6ea3] https://lava.sirena.=
org.uk/scheduler/job/1850231
# test job: [cb3c715d89607f8896c0f20fe528a08e7ebffea9] https://lava.sirena.=
org.uk/scheduler/job/1847506
# test job: [62a7b3bbb6b873fdcc85a37efbd0102d66c8a73e] https://lava.sirena.=
org.uk/scheduler/job/1847919
# test job: [abe962346ef420998d47ba1c2fe591582f69e92e] https://lava.sirena.=
org.uk/scheduler/job/1840571
# test job: [ab63e9910d2d3ea4b8e6c08812258a676defcb9c] https://lava.sirena.=
org.uk/scheduler/job/1838162
# test job: [88d0d17192c5a850dc07bb38035b69c4cefde270] https://lava.sirena.=
org.uk/scheduler/job/1833979
# test job: [8b84d712ad849172f6bbcad57534b284d942b0b5] https://lava.sirena.=
org.uk/scheduler/job/1834047
# test job: [8d7de4a014f589c1776959f7fdadbf7b12045aac] https://lava.sirena.=
org.uk/scheduler/job/1833205
# test job: [6a1f303cba45fa3b612d5a2898b1b1b045eb74e3] https://lava.sirena.=
org.uk/scheduler/job/1830410
# test job: [8b184c34806e5da4d4847fabd3faeff38b47e70a] https://lava.sirena.=
org.uk/scheduler/job/1829609
# test job: [18dda9eb9e11b2aeec73cbe2a56ab2f862841ba4] https://lava.sirena.=
org.uk/scheduler/job/1829367
# test job: [b48b6cc8c655d8cdcf5124ba9901b74c8f759668] https://lava.sirena.=
org.uk/scheduler/job/1903039
# test job: [30db1b21fa37a2f37c7f4d71864405a05e889833] https://lava.sirena.=
org.uk/scheduler/job/1810983
# test job: [59ba108806516adeaed51a536d55d4f5e9645881] https://lava.sirena.=
org.uk/scheduler/job/1810002
# test job: [1217b573978482ae7d21dc5c0bf5aa5007b24f90] https://lava.sirena.=
org.uk/scheduler/job/1809911
# test job: [2e0fd4583d0efcdc260e61a22666c8368f505353] https://lava.sirena.=
org.uk/scheduler/job/1806775
# test job: [d9e33b38c89f4cf8c32b8481dbcf3a6cdbba4595] https://lava.sirena.=
org.uk/scheduler/job/1800073
# test job: [e5b4ad2183f7ab18aaf7c73a120d17241ee58e97] https://lava.sirena.=
org.uk/scheduler/job/1799477
# test job: [3fcc8e146935415d69ffabb5df40ecf50e106131] https://lava.sirena.=
org.uk/scheduler/job/1903146
# test job: [4336efb59ef364e691ef829a73d9dbd4d5ed7c7b] https://lava.sirena.=
org.uk/scheduler/job/1795857
# test job: [5bad16482c2a7e788c042d98f3e97d3b2bbc8cc5] https://lava.sirena.=
org.uk/scheduler/job/1795934
# test job: [1cf87861a2e02432fb68f8bcc8f20a8e42acde59] https://lava.sirena.=
org.uk/scheduler/job/1795025
# test job: [7d083666123a425ba9f81dff1a52955b1f226540] https://lava.sirena.=
org.uk/scheduler/job/1794810
# test job: [2c625f0fe2db4e6a58877ce2318df3aa312eb791] https://lava.sirena.=
org.uk/scheduler/job/1794522
# test job: [b497e1a1a2b10c4ddb28064fba229365ae03311a] https://lava.sirena.=
org.uk/scheduler/job/1780195
# test job: [9e5eb8b49ffe3c173bf7b8c338a57dfa09fb4634] https://lava.sirena.=
org.uk/scheduler/job/1779416
# test job: [0ccc1eeda155c947d88ef053e0b54e434e218ee2] https://lava.sirena.=
org.uk/scheduler/job/1772999
# test job: [7748328c2fd82efed24257b2bfd796eb1fa1d09b] https://lava.sirena.=
org.uk/scheduler/job/1773345
# test job: [dd7ae5b8b3c291c0206f127a564ae1e316705ca0] https://lava.sirena.=
org.uk/scheduler/job/1773213
# test job: [ce57b718006a069226b5e5d3afe7969acd59154e] https://lava.sirena.=
org.uk/scheduler/job/1768668
# test job: [5cc49b5a36b32a2dba41441ea13b93fb5ea21cfd] https://lava.sirena.=
org.uk/scheduler/job/1769259
# test job: [94b39cb3ad6db935b585988b36378884199cd5fc] https://lava.sirena.=
org.uk/scheduler/job/1768574
# test job: [ce1a46b2d6a8465a86f7a6f71beb4c6de83bce5c] https://lava.sirena.=
org.uk/scheduler/job/1768952
# test job: [3279052eab235bfb7130b1fabc74029c2260ed8d] https://lava.sirena.=
org.uk/scheduler/job/1762386
# test job: [9d35d068fb138160709e04e3ee97fe29a6f8615b] https://lava.sirena.=
org.uk/scheduler/job/1758618
# test job: [8f57dcf39fd0864f5f3e6701fe885e55f45d0d3a] https://lava.sirena.=
org.uk/scheduler/job/1760087
# test job: [8a9772ec08f87c9e45ab1ad2c8d2b8c1763836eb] https://lava.sirena.=
org.uk/scheduler/job/1758562
# test job: [3d439e1ec3368fae17db379354bd7a9e568ca0ab] https://lava.sirena.=
org.uk/scheduler/job/1753428
# test job: [d57d27171c92e9049d5301785fb38de127b28fbf] https://lava.sirena.=
org.uk/scheduler/job/1752594
# test job: [f7c41911ad744177d8289820f01009dc93d8f91c] https://lava.sirena.=
org.uk/scheduler/job/1752346
# test job: [07752abfa5dbf7cb4d9ce69fa94dc3b12bc597d9] https://lava.sirena.=
org.uk/scheduler/job/1752248
# test job: [f522da9ab56c96db8703b2ea0f09be7cdc3bffeb] https://lava.sirena.=
org.uk/scheduler/job/1751852
# test job: [5c39bc498f5ff7ef016abf3f16698f3e8db79677] https://lava.sirena.=
org.uk/scheduler/job/1751922
# test job: [f4672dc6e9c07643c8c755856ba8e9eb9ca95d0c] https://lava.sirena.=
org.uk/scheduler/job/1747852
# test job: [ff9a7857b7848227788f113d6dc6a72e989084e0] https://lava.sirena.=
org.uk/scheduler/job/1746307
# test job: [edb5c1f885207d1d74e8a1528e6937e02829ee6e] https://lava.sirena.=
org.uk/scheduler/job/1746105
# test job: [b088b6189a4066b97cef459afd312fd168a76dea] https://lava.sirena.=
org.uk/scheduler/job/1746151
# test job: [a37280daa4d583c7212681c49b285de9464a5200] https://lava.sirena.=
org.uk/scheduler/job/1746890
# test job: [899fb38dd76dd3ede425bbaf8a96d390180a5d1c] https://lava.sirena.=
org.uk/scheduler/job/1747367
# test job: [e2ab5f600bb01d3625d667d97b3eb7538e388336] https://lava.sirena.=
org.uk/scheduler/job/1746552
# test job: [11f5c5f9e43e9020bae452232983fe98e7abfce0] https://lava.sirena.=
org.uk/scheduler/job/1747475
# test job: [5b4dcaf851df8c414bfc2ac3bf9c65fc942f3be4] https://lava.sirena.=
org.uk/scheduler/job/1747628
# test job: [c42e36a488c7e01f833fc9f4814f735b66b2d494] https://lava.sirena.=
org.uk/scheduler/job/1746229
# test job: [a12b74d2bd4724ee1883bc97ec93eac8fafc8d3c] https://lava.sirena.=
org.uk/scheduler/job/1734032
# test job: [f840737d1746398c2993be34bfdc80bdc19ecae2] https://lava.sirena.=
org.uk/scheduler/job/1727343
# test job: [d78e48ebe04e9566f8ecbf51471e80da3adbceeb] https://lava.sirena.=
org.uk/scheduler/job/1706158
# test job: [c232495d28ca092d0c39b10e35d3d613bd2414ab] https://lava.sirena.=
org.uk/scheduler/job/1699614
# test job: [96bcb34df55f7fee99795127c796315950c94fed] https://lava.sirena.=
org.uk/scheduler/job/1699503
# test job: [ec0be3cdf40b5302248f3fb27a911cc630e8b855] https://lava.sirena.=
org.uk/scheduler/job/1694263
# test job: [41f6710f99f4337924e3929e8e7a51c74f800b91] https://lava.sirena.=
org.uk/scheduler/job/1794186
# test job: [da9881d00153cc6d3917f6b74144b1d41b58338c] https://lava.sirena.=
org.uk/scheduler/job/1693368
# test job: [c1dd310f1d76b4b13f1854618087af2513140897] https://lava.sirena.=
org.uk/scheduler/job/1692975
# test job: [27848c082ba0b22850fd9fb7b185c015423dcdc7] https://lava.sirena.=
org.uk/scheduler/job/1693072
# test job: [90179609efa421b1ccc7d8eafbc078bafb25777c] https://lava.sirena.=
org.uk/scheduler/job/1686027
# test job: [2a55135201d5e24b80b7624880ff42eafd8e320c] https://lava.sirena.=
org.uk/scheduler/job/1685741
# test job: [550bc517e59347b3b1af7d290eac4fb1411a3d4e] https://lava.sirena.=
org.uk/scheduler/job/1685897
# test job: [0056b410355713556d8a10306f82e55b28d33ba8] https://lava.sirena.=
org.uk/scheduler/job/1685638
# test job: [cf65182247761f7993737b710afe8c781699356b] https://lava.sirena.=
org.uk/scheduler/job/1687543
# test job: [daf855f76a1210ceed9541f71ac5dd9be02018a6] https://lava.sirena.=
org.uk/scheduler/job/1685502
# test job: [6d068f1ae2a2f713d7f21a9a602e65b3d6b6fc6d] https://lava.sirena.=
org.uk/scheduler/job/1673114
# test job: [258384d8ce365dddd6c5c15204de8ccd53a7ab0a] https://lava.sirena.=
org.uk/scheduler/job/1673366
# test job: [a46e95c81e3a28926ab1904d9f754fef8318074d] https://lava.sirena.=
org.uk/scheduler/job/1673760
# test job: [0e62438e476494a1891a8822b9785bc6e73e9c3f] https://lava.sirena.=
org.uk/scheduler/job/1669505
# test job: [48124569bbc6bfda1df3e9ee17b19d559f4b1aa3] https://lava.sirena.=
org.uk/scheduler/job/1670164
# test job: [37533933bfe92cd5a99ef4743f31dac62ccc8de0] https://lava.sirena.=
org.uk/scheduler/job/1668997
# test job: [5c36b86d2bf68fbcad16169983ef7ee8c537db59] https://lava.sirena.=
org.uk/scheduler/job/1667928
# test job: [714165e1c4b0d5b8c6d095fe07f65e6e7047aaeb] https://lava.sirena.=
org.uk/scheduler/job/1667833
# test job: [9c45f95222beecd6a284fd1284d54dd7a772cf59] https://lava.sirena.=
org.uk/scheduler/job/1667588
# test job: [bab4ab484a6ca170847da9bffe86f1fa90df4bbe] https://lava.sirena.=
org.uk/scheduler/job/1664687
# test job: [b832b19318534bb4f1673b24d78037fee339c679] https://lava.sirena.=
org.uk/scheduler/job/1659182
# test job: [8c02c8353460f8630313aef6810f34e134a3c1ee] https://lava.sirena.=
org.uk/scheduler/job/1659241
# test job: [6b7e2aa50bdaf88cd4c2a5e2059a7bf32d85a8b1] https://lava.sirena.=
org.uk/scheduler/job/1656536
# test job: [a54ef14188519a0994d0264f701f5771815fa11e] https://lava.sirena.=
org.uk/scheduler/job/1655953
# test job: [2291a2186305faaf8525d57849d8ba12ad63f5e7] https://lava.sirena.=
org.uk/scheduler/job/1655935
# test job: [886f42ce96e7ce80545704e7168a9c6b60cd6c03] https://lava.sirena.=
org.uk/scheduler/job/1654283
# test job: [162e23657e5379f07c6404dbfbf4367cb438ea7d] https://lava.sirena.=
org.uk/scheduler/job/1652965
# test job: [a1d0b0ae65ae3f32597edfbb547f16c75601cd87] https://lava.sirena.=
org.uk/scheduler/job/1654192
# test job: [595b7f155b926460a00776cc581e4dcd01220006] https://lava.sirena.=
org.uk/scheduler/job/1654091
# test job: [cf25eb8eae91bcae9b2065d84b0c0ba0f6d9dd34] https://lava.sirena.=
org.uk/scheduler/job/1654783
# test job: [3059067fd3378a5454e7928c08d20bf3ef186760] https://lava.sirena.=
org.uk/scheduler/job/1654023
# test job: [9a200cbdb54349909a42b45379e792e4b39dd223] https://lava.sirena.=
org.uk/scheduler/job/1654710
# test job: [2d86d2585ab929a143d1e6f8963da1499e33bf13] https://lava.sirena.=
org.uk/scheduler/job/1654119
# test job: [d9043c79ba68a089f95bb4344ab0232c3585f9f1] https://lava.sirena.=
org.uk/scheduler/job/1972016
# bad: [d9043c79ba68a089f95bb4344ab0232c3585f9f1] Merge tag 'sched_urgent_f=
or_v6.18_rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad d9043c79ba68a089f95bb4344ab0232c3585f9f1
# test job: [d303caf5caf453da2abfd84d249d210aaffe9873] https://lava.sirena.=
org.uk/scheduler/job/1970092
# bad: [d303caf5caf453da2abfd84d249d210aaffe9873] Merge tag 'bpf-fixes' of =
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
git bisect bad d303caf5caf453da2abfd84d249d210aaffe9873
# test job: [211ddde0823f1442e4ad052a2f30f050145ccada] https://lava.sirena.=
org.uk/scheduler/job/1976550
# bad: [211ddde0823f1442e4ad052a2f30f050145ccada] Linux 6.18-rc2
git bisect bad 211ddde0823f1442e4ad052a2f30f050145ccada
# test job: [02e5f74ef08d3e6afec438d571487d0d0cec3c48] https://lava.sirena.=
org.uk/scheduler/job/1978549
# bad: [02e5f74ef08d3e6afec438d571487d0d0cec3c48] Merge tag 'for-linus' of =
git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect bad 02e5f74ef08d3e6afec438d571487d0d0cec3c48
# test job: [1c64efcb083c48c85227cb4d72ab137feef2cdac] https://lava.sirena.=
org.uk/scheduler/job/1970718
# bad: [1c64efcb083c48c85227cb4d72ab137feef2cdac] Merge tag 'rust-rustfmt' =
of git://git.kernel.org/pub/scm/linux/kernel/git/ojeda/linux
git bisect bad 1c64efcb083c48c85227cb4d72ab137feef2cdac
# test job: [5c7cf1e44e94a5408b1b5277810502b0f82b77fe] https://lava.sirena.=
org.uk/scheduler/job/1978730
# bad: [5c7cf1e44e94a5408b1b5277810502b0f82b77fe] KVM: arm64: selftests: Fi=
x misleading comment about virtual timer encoding
git bisect bad 5c7cf1e44e94a5408b1b5277810502b0f82b77fe
# test job: [3193287ddffbce29fd1a79d812f543c0fe4861d1] https://lava.sirena.=
org.uk/scheduler/job/1979313
# bad: [3193287ddffbce29fd1a79d812f543c0fe4861d1] KVM: arm64: gic-v3: Only =
set ICH_HCR traps for v2-on-v3 or v3 guests
git bisect bad 3193287ddffbce29fd1a79d812f543c0fe4861d1
# test job: [cc4309324dc695f62d25d56c0b29805e9724170c] https://lava.sirena.=
org.uk/scheduler/job/1980154
# good: [cc4309324dc695f62d25d56c0b29805e9724170c] KVM: arm64: Document vCP=
U event ioctls as requiring init'ed vCPU
git bisect good cc4309324dc695f62d25d56c0b29805e9724170c
# test job: [9a7f87eb587da49993f47f44c4c5535d8de76750] https://lava.sirena.=
org.uk/scheduler/job/1980663
# good: [9a7f87eb587da49993f47f44c4c5535d8de76750] KVM: arm64: selftests: S=
ync ID_AA64PFR1, MPIDR, CLIDR in guest
git bisect good 9a7f87eb587da49993f47f44c4c5535d8de76750
# test job: [2192d348c0aa0cc2e7249dc3709f21bfe0a0170c] https://lava.sirena.=
org.uk/scheduler/job/1980777
# good: [2192d348c0aa0cc2e7249dc3709f21bfe0a0170c] KVM: arm64: selftests: A=
llocate vcpus with correct size
git bisect good 2192d348c0aa0cc2e7249dc3709f21bfe0a0170c
# test job: [d5e6310a0d996493b1af9f3eeec418350523388b] https://lava.sirena.=
org.uk/scheduler/job/1981214
# good: [d5e6310a0d996493b1af9f3eeec418350523388b] KVM: arm64: selftests: A=
ctually enable IRQs in vgic_lpi_stress
git bisect good d5e6310a0d996493b1af9f3eeec418350523388b
# first bad commit: [3193287ddffbce29fd1a79d812f543c0fe4861d1] KVM: arm64: =
gic-v3: Only set ICH_HCR traps for v2-on-v3 or v3 guests
   https://lava.sirena.org.uk/scheduler/job/1976550#L4100

--Hai4KbcOHSUNYB1M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj20iMACgkQJNaLcl1U
h9AGlQf9FgtznhjCMGSGXDuGscHvE5XT4TSTSXInK9GHiaJKn4d7QFjSjywzigpP
LALGBTa+mYR6xP5vnm3dn/+8V4xG4Vgcn4CpDVbT4F7UrA+rg9ZJUwdgVrHwW5jx
i6jW/da/qHFk+eOFcadyGfJzLghekXVsRBSSxuWxcJ/ZabgIvanXXGqDYFkI92zC
335qdFZMc+E5GWM2D7E6Ct2jwhmCLLzBzskBf0zI4kEjgKEFO0Knrjvb92SVDlAz
Ofzm2A6oBvnQcQN8QuVTnkWwMlQSbkv+YjS2CjE0kkOVHJIJTZxywCmPeUhFsyUl
4ZV4G9fv91Ouc/nSX0T3v/9TUI6xxw==
=9Y+m
-----END PGP SIGNATURE-----

--Hai4KbcOHSUNYB1M--

