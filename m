Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2970E2F2417
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 01:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391756AbhALAZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 19:25:43 -0500
Received: from ozlabs.org ([203.11.71.1]:60695 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404261AbhALASO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 19:18:14 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFB3Y1MXYz9sXL; Tue, 12 Jan 2021 11:17:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610410649;
        bh=1m9CFUJWDc1K3efCRtER5BXji20nMK9ORxssP08gPOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EmK8yFmNjhty2H8d/TeTkv4G2pYqTYgSKL2CctRvWlQ2XQQqINNr8LJh7iorythyL
         qVp/iW0DudL/a0N6ucE1Lzl1KphdI0wDdkF5OEhrZuSqxCkg7jDVC7u0OaTL71N9Bv
         RdXim3HExE/tugdoXsGjR/mPpghdmgIEIrVqVY2U=
Date:   Tue, 12 Jan 2021 11:17:20 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Huacai Chen <chenhuacai@kernel.org>,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-trivial@nongnu.org,
        Amit Shah <amit@kernel.org>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        qemu-arm@nongnu.org, John Snow <jsnow@redhat.com>,
        qemu-s390x@nongnu.org, Paul Durrant <paul@xen.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Halil Pasic <pasic@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Thomas Huth <thuth@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 2/2] sysemu: Let VMChangeStateHandler take boolean
 'running' argument
Message-ID: <20210112001720.GH3051@yekko.fritz.box>
References: <20210111152020.1422021-1-philmd@redhat.com>
 <20210111152020.1422021-3-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+QwZB9vYiNIzNXIj"
Content-Disposition: inline
In-Reply-To: <20210111152020.1422021-3-philmd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--+QwZB9vYiNIzNXIj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 11, 2021 at 04:20:20PM +0100, Philippe Mathieu-Daud=E9 wrote:
> The 'running' argument from VMChangeStateHandler does not require
> other value than 0 / 1. Make it a plain boolean.
>=20
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>

ppc parts
Acked-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  include/sysemu/runstate.h   | 10 ++++++++--
>  target/arm/kvm_arm.h        |  2 +-
>  target/ppc/cpu-qom.h        |  2 +-
>  accel/xen/xen-all.c         |  2 +-
>  audio/audio.c               |  2 +-
>  block/block-backend.c       |  2 +-
>  gdbstub.c                   |  2 +-
>  hw/block/pflash_cfi01.c     |  2 +-
>  hw/block/virtio-blk.c       |  2 +-
>  hw/display/qxl.c            |  2 +-
>  hw/i386/kvm/clock.c         |  2 +-
>  hw/i386/kvm/i8254.c         |  2 +-
>  hw/i386/kvmvapic.c          |  2 +-
>  hw/i386/xen/xen-hvm.c       |  2 +-
>  hw/ide/core.c               |  2 +-
>  hw/intc/arm_gicv3_its_kvm.c |  2 +-
>  hw/intc/arm_gicv3_kvm.c     |  2 +-
>  hw/intc/spapr_xive_kvm.c    |  2 +-
>  hw/misc/mac_via.c           |  2 +-
>  hw/net/e1000e_core.c        |  2 +-
>  hw/nvram/spapr_nvram.c      |  2 +-
>  hw/ppc/ppc.c                |  2 +-
>  hw/ppc/ppc_booke.c          |  2 +-
>  hw/s390x/tod-kvm.c          |  2 +-
>  hw/scsi/scsi-bus.c          |  2 +-
>  hw/usb/hcd-ehci.c           |  2 +-
>  hw/usb/host-libusb.c        |  2 +-
>  hw/usb/redirect.c           |  2 +-
>  hw/vfio/migration.c         |  2 +-
>  hw/virtio/virtio-rng.c      |  2 +-
>  hw/virtio/virtio.c          |  2 +-
>  net/net.c                   |  2 +-
>  softmmu/memory.c            |  2 +-
>  softmmu/runstate.c          |  2 +-
>  target/arm/kvm.c            |  2 +-
>  target/i386/kvm/kvm.c       |  2 +-
>  target/i386/sev.c           |  2 +-
>  target/i386/whpx/whpx-all.c |  2 +-
>  target/mips/kvm.c           |  4 ++--
>  ui/gtk.c                    |  2 +-
>  ui/spice-core.c             |  2 +-
>  41 files changed, 49 insertions(+), 43 deletions(-)
>=20
> diff --git a/include/sysemu/runstate.h b/include/sysemu/runstate.h
> index 3ab35a039a0..a5356915734 100644
> --- a/include/sysemu/runstate.h
> +++ b/include/sysemu/runstate.h
> @@ -10,7 +10,7 @@ bool runstate_is_running(void);
>  bool runstate_needs_reset(void);
>  bool runstate_store(char *str, size_t size);
> =20
> -typedef void VMChangeStateHandler(void *opaque, int running, RunState st=
ate);
> +typedef void VMChangeStateHandler(void *opaque, bool running, RunState s=
tate);
> =20
>  VMChangeStateEntry *qemu_add_vm_change_state_handler(VMChangeStateHandle=
r *cb,
>                                                       void *opaque);
> @@ -20,7 +20,13 @@ VMChangeStateEntry *qdev_add_vm_change_state_handler(D=
eviceState *dev,
>                                                       VMChangeStateHandle=
r *cb,
>                                                       void *opaque);
>  void qemu_del_vm_change_state_handler(VMChangeStateEntry *e);
> -void vm_state_notify(int running, RunState state);
> +/**
> + * vm_state_notify: Notify the state of the VM
> + *
> + * @running: whether the VM is running or not.
> + * @state: the #RunState of the VM.
> + */
> +void vm_state_notify(bool running, RunState state);
> =20
>  static inline bool shutdown_caused_by_guest(ShutdownCause cause)
>  {
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index eb81b7059eb..68ec970c4f4 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -352,7 +352,7 @@ void kvm_arm_get_virtual_time(CPUState *cs);
>   */
>  void kvm_arm_put_virtual_time(CPUState *cs);
> =20
> -void kvm_arm_vm_state_change(void *opaque, int running, RunState state);
> +void kvm_arm_vm_state_change(void *opaque, bool running, RunState state);
> =20
>  int kvm_arm_vgic_probe(void);
> =20
> diff --git a/target/ppc/cpu-qom.h b/target/ppc/cpu-qom.h
> index 63b9e8632ca..118baf8d41f 100644
> --- a/target/ppc/cpu-qom.h
> +++ b/target/ppc/cpu-qom.h
> @@ -218,7 +218,7 @@ extern const VMStateDescription vmstate_ppc_timebase;
>      .offset     =3D vmstate_offset_value(_state, _field, PPCTimebase),  \
>  }
> =20
> -void cpu_ppc_clock_vm_state_change(void *opaque, int running,
> +void cpu_ppc_clock_vm_state_change(void *opaque, bool running,
>                                     RunState state);
>  #endif
> =20
> diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
> index 878a4089d97..3756aca27be 100644
> --- a/accel/xen/xen-all.c
> +++ b/accel/xen/xen-all.c
> @@ -122,7 +122,7 @@ static void xenstore_record_dm_state(struct xs_handle=
 *xs, const char *state)
>  }
> =20
> =20
> -static void xen_change_state_handler(void *opaque, int running,
> +static void xen_change_state_handler(void *opaque, bool running,
>                                       RunState state)
>  {
>      if (running) {
> diff --git a/audio/audio.c b/audio/audio.c
> index b48471bb3f6..f2d56e7e57d 100644
> --- a/audio/audio.c
> +++ b/audio/audio.c
> @@ -1549,7 +1549,7 @@ static int audio_driver_init(AudioState *s, struct =
audio_driver *drv,
>      }
>  }
> =20
> -static void audio_vm_change_state_handler (void *opaque, int running,
> +static void audio_vm_change_state_handler (void *opaque, bool running,
>                                             RunState state)
>  {
>      AudioState *s =3D opaque;
> diff --git a/block/block-backend.c b/block/block-backend.c
> index ce78d30794a..9175eb237a2 100644
> --- a/block/block-backend.c
> +++ b/block/block-backend.c
> @@ -163,7 +163,7 @@ static const char *blk_root_get_name(BdrvChild *child)
>      return blk_name(child->opaque);
>  }
> =20
> -static void blk_vm_state_changed(void *opaque, int running, RunState sta=
te)
> +static void blk_vm_state_changed(void *opaque, bool running, RunState st=
ate)
>  {
>      Error *local_err =3D NULL;
>      BlockBackend *blk =3D opaque;
> diff --git a/gdbstub.c b/gdbstub.c
> index d99bc0bf2ea..9f2998f8d03 100644
> --- a/gdbstub.c
> +++ b/gdbstub.c
> @@ -2691,7 +2691,7 @@ void gdb_set_stop_cpu(CPUState *cpu)
>  }
> =20
>  #ifndef CONFIG_USER_ONLY
> -static void gdb_vm_state_change(void *opaque, int running, RunState stat=
e)
> +static void gdb_vm_state_change(void *opaque, bool running, RunState sta=
te)
>  {
>      CPUState *cpu =3D gdbserver_state.c_cpu;
>      g_autoptr(GString) buf =3D g_string_new(NULL);
> diff --git a/hw/block/pflash_cfi01.c b/hw/block/pflash_cfi01.c
> index ccf326793db..badcbccf012 100644
> --- a/hw/block/pflash_cfi01.c
> +++ b/hw/block/pflash_cfi01.c
> @@ -1014,7 +1014,7 @@ void pflash_cfi01_legacy_drive(PFlashCFI01 *fl, Dri=
veInfo *dinfo)
>      loc_pop(&loc);
>  }
> =20
> -static void postload_update_cb(void *opaque, int running, RunState state)
> +static void postload_update_cb(void *opaque, bool running, RunState stat=
e)
>  {
>      PFlashCFI01 *pfl =3D opaque;
> =20
> diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
> index bac2d6fa2b2..5207ef617f0 100644
> --- a/hw/block/virtio-blk.c
> +++ b/hw/block/virtio-blk.c
> @@ -870,7 +870,7 @@ static void virtio_blk_dma_restart_bh(void *opaque)
>      virtio_blk_process_queued_requests(s, true);
>  }
> =20
> -static void virtio_blk_dma_restart_cb(void *opaque, int running,
> +static void virtio_blk_dma_restart_cb(void *opaque, bool running,
>                                        RunState state)
>  {
>      VirtIOBlock *s =3D opaque;
> diff --git a/hw/display/qxl.c b/hw/display/qxl.c
> index 431c1070967..d22e84ba13e 100644
> --- a/hw/display/qxl.c
> +++ b/hw/display/qxl.c
> @@ -1992,7 +1992,7 @@ static void qxl_dirty_surfaces(PCIQXLDevice *qxl)
>      }
>  }
> =20
> -static void qxl_vm_change_state_handler(void *opaque, int running,
> +static void qxl_vm_change_state_handler(void *opaque, bool running,
>                                          RunState state)
>  {
>      PCIQXLDevice *qxl =3D opaque;
> diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
> index 2d8a3663693..51872dd84c0 100644
> --- a/hw/i386/kvm/clock.c
> +++ b/hw/i386/kvm/clock.c
> @@ -162,7 +162,7 @@ static void do_kvmclock_ctrl(CPUState *cpu, run_on_cp=
u_data data)
>      }
>  }
> =20
> -static void kvmclock_vm_state_change(void *opaque, int running,
> +static void kvmclock_vm_state_change(void *opaque, bool running,
>                                       RunState state)
>  {
>      KVMClockState *s =3D opaque;
> diff --git a/hw/i386/kvm/i8254.c b/hw/i386/kvm/i8254.c
> index c73254e8866..c558893961b 100644
> --- a/hw/i386/kvm/i8254.c
> +++ b/hw/i386/kvm/i8254.c
> @@ -239,7 +239,7 @@ static void kvm_pit_irq_control(void *opaque, int n, =
int enable)
>      kvm_pit_put(pit);
>  }
> =20
> -static void kvm_pit_vm_state_change(void *opaque, int running,
> +static void kvm_pit_vm_state_change(void *opaque, bool running,
>                                      RunState state)
>  {
>      KVMPITState *s =3D opaque;
> diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
> index 2c1898032e4..46315445d22 100644
> --- a/hw/i386/kvmvapic.c
> +++ b/hw/i386/kvmvapic.c
> @@ -748,7 +748,7 @@ static void do_vapic_enable(CPUState *cs, run_on_cpu_=
data data)
>      s->state =3D VAPIC_ACTIVE;
>  }
> =20
> -static void kvmvapic_vm_state_change(void *opaque, int running,
> +static void kvmvapic_vm_state_change(void *opaque, bool running,
>                                       RunState state)
>  {
>      MachineState *ms =3D MACHINE(qdev_get_machine());
> diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
> index 68821d90f52..7ce672e5a5c 100644
> --- a/hw/i386/xen/xen-hvm.c
> +++ b/hw/i386/xen/xen-hvm.c
> @@ -1235,7 +1235,7 @@ static void xen_main_loop_prepare(XenIOState *state)
>  }
> =20
> =20
> -static void xen_hvm_change_state_handler(void *opaque, int running,
> +static void xen_hvm_change_state_handler(void *opaque, bool running,
>                                           RunState rstate)
>  {
>      XenIOState *state =3D opaque;
> diff --git a/hw/ide/core.c b/hw/ide/core.c
> index b49e4cfbc6c..b5c6e967b2e 100644
> --- a/hw/ide/core.c
> +++ b/hw/ide/core.c
> @@ -2677,7 +2677,7 @@ static void ide_restart_bh(void *opaque)
>      }
>  }
> =20
> -static void ide_restart_cb(void *opaque, int running, RunState state)
> +static void ide_restart_cb(void *opaque, bool running, RunState state)
>  {
>      IDEBus *bus =3D opaque;
> =20
> diff --git a/hw/intc/arm_gicv3_its_kvm.c b/hw/intc/arm_gicv3_its_kvm.c
> index 057cb53f13c..b554d2ede0a 100644
> --- a/hw/intc/arm_gicv3_its_kvm.c
> +++ b/hw/intc/arm_gicv3_its_kvm.c
> @@ -71,7 +71,7 @@ static int kvm_its_send_msi(GICv3ITSState *s, uint32_t =
value, uint16_t devid)
>   *
>   * The tables get flushed to guest RAM whenever the VM gets stopped.
>   */
> -static void vm_change_state_handler(void *opaque, int running,
> +static void vm_change_state_handler(void *opaque, bool running,
>                                      RunState state)
>  {
>      GICv3ITSState *s =3D (GICv3ITSState *)opaque;
> diff --git a/hw/intc/arm_gicv3_kvm.c b/hw/intc/arm_gicv3_kvm.c
> index d040a5d1e99..65a4c880a35 100644
> --- a/hw/intc/arm_gicv3_kvm.c
> +++ b/hw/intc/arm_gicv3_kvm.c
> @@ -743,7 +743,7 @@ static const ARMCPRegInfo gicv3_cpuif_reginfo[] =3D {
>   *
>   * The tables get flushed to guest RAM whenever the VM gets stopped.
>   */
> -static void vm_change_state_handler(void *opaque, int running,
> +static void vm_change_state_handler(void *opaque, bool running,
>                                      RunState state)
>  {
>      GICv3State *s =3D (GICv3State *)opaque;
> diff --git a/hw/intc/spapr_xive_kvm.c b/hw/intc/spapr_xive_kvm.c
> index acc8c3650c4..c0083311607 100644
> --- a/hw/intc/spapr_xive_kvm.c
> +++ b/hw/intc/spapr_xive_kvm.c
> @@ -504,7 +504,7 @@ static int kvmppc_xive_get_queues(SpaprXive *xive, Er=
ror **errp)
>   * runs again. If an interrupt was queued while the VM was stopped,
>   * simply generate a trigger.
>   */
> -static void kvmppc_xive_change_state_handler(void *opaque, int running,
> +static void kvmppc_xive_change_state_handler(void *opaque, bool running,
>                                               RunState state)
>  {
>      SpaprXive *xive =3D opaque;
> diff --git a/hw/misc/mac_via.c b/hw/misc/mac_via.c
> index 488d086a17c..ca2f939dd58 100644
> --- a/hw/misc/mac_via.c
> +++ b/hw/misc/mac_via.c
> @@ -1098,7 +1098,7 @@ static void mac_via_init(Object *obj)
>                          TYPE_ADB_BUS, DEVICE(obj), "adb.0");
>  }
> =20
> -static void postload_update_cb(void *opaque, int running, RunState state)
> +static void postload_update_cb(void *opaque, bool running, RunState stat=
e)
>  {
>      MacVIAState *m =3D MAC_VIA(opaque);
> =20
> diff --git a/hw/net/e1000e_core.c b/hw/net/e1000e_core.c
> index 4dcb92d966b..b75f2ab8fc1 100644
> --- a/hw/net/e1000e_core.c
> +++ b/hw/net/e1000e_core.c
> @@ -3298,7 +3298,7 @@ e1000e_autoneg_resume(E1000ECore *core)
>  }
> =20
>  static void
> -e1000e_vm_state_change(void *opaque, int running, RunState state)
> +e1000e_vm_state_change(void *opaque, bool running, RunState state)
>  {
>      E1000ECore *core =3D opaque;
> =20
> diff --git a/hw/nvram/spapr_nvram.c b/hw/nvram/spapr_nvram.c
> index 9e51bc82ae4..01f77520146 100644
> --- a/hw/nvram/spapr_nvram.c
> +++ b/hw/nvram/spapr_nvram.c
> @@ -217,7 +217,7 @@ static int spapr_nvram_pre_load(void *opaque)
>      return 0;
>  }
> =20
> -static void postload_update_cb(void *opaque, int running, RunState state)
> +static void postload_update_cb(void *opaque, bool running, RunState stat=
e)
>  {
>      SpaprNvram *nvram =3D opaque;
> =20
> diff --git a/hw/ppc/ppc.c b/hw/ppc/ppc.c
> index 5cbbff1f8d0..bf28d6bfc8d 100644
> --- a/hw/ppc/ppc.c
> +++ b/hw/ppc/ppc.c
> @@ -1059,7 +1059,7 @@ static void timebase_load(PPCTimebase *tb)
>      }
>  }
> =20
> -void cpu_ppc_clock_vm_state_change(void *opaque, int running,
> +void cpu_ppc_clock_vm_state_change(void *opaque, bool running,
>                                     RunState state)
>  {
>      PPCTimebase *tb =3D opaque;
> diff --git a/hw/ppc/ppc_booke.c b/hw/ppc/ppc_booke.c
> index 652a21b8064..974c0c8a752 100644
> --- a/hw/ppc/ppc_booke.c
> +++ b/hw/ppc/ppc_booke.c
> @@ -317,7 +317,7 @@ static void ppc_booke_timer_reset_handle(void *opaque)
>   * action will be taken. To avoid this we always clear the watchdog stat=
e when
>   * state changes to running.
>   */
> -static void cpu_state_change_handler(void *opaque, int running, RunState=
 state)
> +static void cpu_state_change_handler(void *opaque, bool running, RunStat=
e state)
>  {
>      PowerPCCPU *cpu =3D opaque;
>      CPUPPCState *env =3D &cpu->env;
> diff --git a/hw/s390x/tod-kvm.c b/hw/s390x/tod-kvm.c
> index 6e21d83181d..0b944774861 100644
> --- a/hw/s390x/tod-kvm.c
> +++ b/hw/s390x/tod-kvm.c
> @@ -78,7 +78,7 @@ static void kvm_s390_tod_set(S390TODState *td, const S3=
90TOD *tod, Error **errp)
>      }
>  }
> =20
> -static void kvm_s390_tod_vm_state_change(void *opaque, int running,
> +static void kvm_s390_tod_vm_state_change(void *opaque, bool running,
>                                           RunState state)
>  {
>      S390TODState *td =3D opaque;
> diff --git a/hw/scsi/scsi-bus.c b/hw/scsi/scsi-bus.c
> index c349fb7f2d1..f990d5b3b03 100644
> --- a/hw/scsi/scsi-bus.c
> +++ b/hw/scsi/scsi-bus.c
> @@ -181,7 +181,7 @@ void scsi_req_retry(SCSIRequest *req)
>      req->retry =3D true;
>  }
> =20
> -static void scsi_dma_restart_cb(void *opaque, int running, RunState stat=
e)
> +static void scsi_dma_restart_cb(void *opaque, bool running, RunState sta=
te)
>  {
>      SCSIDevice *s =3D opaque;
> =20
> diff --git a/hw/usb/hcd-ehci.c b/hw/usb/hcd-ehci.c
> index aca018d8b5f..98d08c325ea 100644
> --- a/hw/usb/hcd-ehci.c
> +++ b/hw/usb/hcd-ehci.c
> @@ -2436,7 +2436,7 @@ static int usb_ehci_post_load(void *opaque, int ver=
sion_id)
>      return 0;
>  }
> =20
> -static void usb_ehci_vm_state_change(void *opaque, int running, RunState=
 state)
> +static void usb_ehci_vm_state_change(void *opaque, bool running, RunStat=
e state)
>  {
>      EHCIState *ehci =3D opaque;
> =20
> diff --git a/hw/usb/host-libusb.c b/hw/usb/host-libusb.c
> index b950501d100..ecbf3f66f42 100644
> --- a/hw/usb/host-libusb.c
> +++ b/hw/usb/host-libusb.c
> @@ -1755,7 +1755,7 @@ type_init(usb_host_register_types)
>  static QEMUTimer *usb_auto_timer;
>  static VMChangeStateEntry *usb_vmstate;
> =20
> -static void usb_host_vm_state(void *unused, int running, RunState state)
> +static void usb_host_vm_state(void *unused, bool running, RunState state)
>  {
>      if (running) {
>          usb_host_auto_check(unused);
> diff --git a/hw/usb/redirect.c b/hw/usb/redirect.c
> index 7e9e3fecbfe..17f06f34179 100644
> --- a/hw/usb/redirect.c
> +++ b/hw/usb/redirect.c
> @@ -1395,7 +1395,7 @@ static void usbredir_chardev_event(void *opaque, QE=
MUChrEvent event)
>   * init + destroy
>   */
> =20
> -static void usbredir_vm_state_change(void *priv, int running, RunState s=
tate)
> +static void usbredir_vm_state_change(void *priv, bool running, RunState =
state)
>  {
>      USBRedirDevice *dev =3D priv;
> =20
> diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
> index 00daa50ed81..134bdccc4f8 100644
> --- a/hw/vfio/migration.c
> +++ b/hw/vfio/migration.c
> @@ -727,7 +727,7 @@ static SaveVMHandlers savevm_vfio_handlers =3D {
> =20
>  /* ---------------------------------------------------------------------=
- */
> =20
> -static void vfio_vmstate_change(void *opaque, int running, RunState stat=
e)
> +static void vfio_vmstate_change(void *opaque, bool running, RunState sta=
te)
>  {
>      VFIODevice *vbasedev =3D opaque;
>      VFIOMigration *migration =3D vbasedev->migration;
> diff --git a/hw/virtio/virtio-rng.c b/hw/virtio/virtio-rng.c
> index 76ce9376931..cc8e9f775d8 100644
> --- a/hw/virtio/virtio-rng.c
> +++ b/hw/virtio/virtio-rng.c
> @@ -133,7 +133,7 @@ static uint64_t get_features(VirtIODevice *vdev, uint=
64_t f, Error **errp)
>      return f;
>  }
> =20
> -static void virtio_rng_vm_state_change(void *opaque, int running,
> +static void virtio_rng_vm_state_change(void *opaque, bool running,
>                                         RunState state)
>  {
>      VirtIORNG *vrng =3D opaque;
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index b308026596f..38dc623c89e 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -3208,7 +3208,7 @@ void virtio_cleanup(VirtIODevice *vdev)
>      qemu_del_vm_change_state_handler(vdev->vmstate);
>  }
> =20
> -static void virtio_vmstate_change(void *opaque, int running, RunState st=
ate)
> +static void virtio_vmstate_change(void *opaque, bool running, RunState s=
tate)
>  {
>      VirtIODevice *vdev =3D opaque;
>      BusState *qbus =3D qdev_get_parent_bus(DEVICE(vdev));
> diff --git a/net/net.c b/net/net.c
> index e1035f21d18..8a85d1e3f7b 100644
> --- a/net/net.c
> +++ b/net/net.c
> @@ -1341,7 +1341,7 @@ void qmp_set_link(const char *name, bool up, Error =
**errp)
>      }
>  }
> =20
> -static void net_vm_change_state_handler(void *opaque, int running,
> +static void net_vm_change_state_handler(void *opaque, bool running,
>                                          RunState state)
>  {
>      NetClientState *nc;
> diff --git a/softmmu/memory.c b/softmmu/memory.c
> index 333e1ed7b05..ab7f2e5aa07 100644
> --- a/softmmu/memory.c
> +++ b/softmmu/memory.c
> @@ -2675,7 +2675,7 @@ static void memory_global_dirty_log_do_stop(void)
>      MEMORY_LISTENER_CALL_GLOBAL(log_global_stop, Reverse);
>  }
> =20
> -static void memory_vm_change_state_handler(void *opaque, int running,
> +static void memory_vm_change_state_handler(void *opaque, bool running,
>                                             RunState state)
>  {
>      if (running) {
> diff --git a/softmmu/runstate.c b/softmmu/runstate.c
> index c7a67147d17..cb07a65925c 100644
> --- a/softmmu/runstate.c
> +++ b/softmmu/runstate.c
> @@ -316,7 +316,7 @@ void qemu_del_vm_change_state_handler(VMChangeStateEn=
try *e)
>      g_free(e);
>  }
> =20
> -void vm_state_notify(int running, RunState state)
> +void vm_state_notify(bool running, RunState state)
>  {
>      VMChangeStateEntry *e, *next;
> =20
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index ffe186de8d1..53d6c4a17eb 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -844,7 +844,7 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm=
_run *run)
>      return MEMTXATTRS_UNSPECIFIED;
>  }
> =20
> -void kvm_arm_vm_state_change(void *opaque, int running, RunState state)
> +void kvm_arm_vm_state_change(void *opaque, bool running, RunState state)
>  {
>      CPUState *cs =3D opaque;
>      ARMCPU *cpu =3D ARM_CPU(cs);
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 6dc1ee052d5..170ad55c09c 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -690,7 +690,7 @@ static int kvm_inject_mce_oldstyle(X86CPU *cpu)
>      return 0;
>  }
> =20
> -static void cpu_update_state(void *opaque, int running, RunState state)
> +static void cpu_update_state(void *opaque, bool running, RunState state)
>  {
>      CPUX86State *env =3D opaque;
> =20
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 15466068118..e7890f61906 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -670,7 +670,7 @@ sev_launch_finish(SevGuestState *sev)
>  }
> =20
>  static void
> -sev_vm_state_change(void *opaque, int running, RunState state)
> +sev_vm_state_change(void *opaque, bool running, RunState state)
>  {
>      SevGuestState *sev =3D opaque;
> =20
> diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
> index 3b824fc9d7c..850dfe72e75 100644
> --- a/target/i386/whpx/whpx-all.c
> +++ b/target/i386/whpx/whpx-all.c
> @@ -1318,7 +1318,7 @@ void whpx_cpu_synchronize_pre_loadvm(CPUState *cpu)
> =20
>  static Error *whpx_migration_blocker;
> =20
> -static void whpx_cpu_update_state(void *opaque, int running, RunState st=
ate)
> +static void whpx_cpu_update_state(void *opaque, bool running, RunState s=
tate)
>  {
>      CPUX86State *env =3D opaque;
> =20
> diff --git a/target/mips/kvm.c b/target/mips/kvm.c
> index 477692566a4..09945ad2455 100644
> --- a/target/mips/kvm.c
> +++ b/target/mips/kvm.c
> @@ -37,7 +37,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[=
] =3D {
>      KVM_CAP_LAST_INFO
>  };
> =20
> -static void kvm_mips_update_state(void *opaque, int running, RunState st=
ate);
> +static void kvm_mips_update_state(void *opaque, bool running, RunState s=
tate);
> =20
>  unsigned long kvm_arch_vcpu_id(CPUState *cs)
>  {
> @@ -552,7 +552,7 @@ static int kvm_mips_restore_count(CPUState *cs)
>  /*
>   * Handle the VM clock being started or stopped
>   */
> -static void kvm_mips_update_state(void *opaque, int running, RunState st=
ate)
> +static void kvm_mips_update_state(void *opaque, bool running, RunState s=
tate)
>  {
>      CPUState *cs =3D opaque;
>      int ret;
> diff --git a/ui/gtk.c b/ui/gtk.c
> index a752aa22be0..a5bf8ed8429 100644
> --- a/ui/gtk.c
> +++ b/ui/gtk.c
> @@ -672,7 +672,7 @@ static const DisplayChangeListenerOps dcl_egl_ops =3D=
 {
> =20
>  /** QEMU Events **/
> =20
> -static void gd_change_runstate(void *opaque, int running, RunState state)
> +static void gd_change_runstate(void *opaque, bool running, RunState stat=
e)
>  {
>      GtkDisplayState *s =3D opaque;
> =20
> diff --git a/ui/spice-core.c b/ui/spice-core.c
> index 5746d0aae7c..22c77c04151 100644
> --- a/ui/spice-core.c
> +++ b/ui/spice-core.c
> @@ -622,7 +622,7 @@ static int add_channel(void *opaque, const char *name=
, const char *value,
>      return 0;
>  }
> =20
> -static void vm_change_state_handler(void *opaque, int running,
> +static void vm_change_state_handler(void *opaque, bool running,
>                                      RunState state)
>  {
>      if (running) {

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--+QwZB9vYiNIzNXIj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/86pAACgkQbDjKyiDZ
s5IGOw//WIs3+bY1FR4DvAxX+bm4u89ANESdE7T1XDqZ9dZYwC/P1zUMBSlaMb3X
7Ba8YtNMCtHcrTFvCY7ftx8VDkrzwAP6TgPbWbapfpKPibM2zEJ1auioEqaYssdU
D6qclNPWXphv6uWlRQNzDvbp9+f/PICnp9L5DJOiFFFAlXSCwFJjinrDVEb14pFs
/p37oMyOWSlrLe12fSSuZhcrZyoL2ElGn8NNZiH1yVtUZvIeqenLQzdNY4qcyIBY
0JrOEtCt84UIrZ6PKtsVCnferPhUGdW5zrU+0VSlZKITVwAlbmYOoICnv063PG0A
5LcmAPCTQDU+PTpaoSQOFb9GqZjKf0GnTrdUrggENiIHmM4HUyiWxVUpSa/emeuT
/xtmKmmPDyyy9HpdkpHZ05AchzIuXkIKG6NjXmXOuLxpDQbpc0PV9oAhUBvatI8L
JC9RAyPtn5KzDXWJVaoQIMqjepxIkc/hn/s2WjU6nw6bEzJ+0RuQatjx+Tty5qOE
ufov4krLArtfD63UzYgIj187f/I7aFQmoaVULyp6O8I6ixML4/SjLOtECZ9o/q4k
o8NiBQVW8AUBqmthdFHW13aDAxTnPPuQBCd/HDZQxT78D418cHjAiTAoU5q9yQDR
ye4B2gB6AGrrX7e5iMG9q7BEJPiu6D/3hcQNzXFO2wLD9AWFdHk=
=eZ3g
-----END PGP SIGNATURE-----

--+QwZB9vYiNIzNXIj--
