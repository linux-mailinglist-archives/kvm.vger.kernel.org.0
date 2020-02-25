Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEF016C0D2
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 13:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgBYMag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 07:30:36 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:16720 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729179AbgBYMaf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 07:30:35 -0500
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2020 07:30:33 EST
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PCDn8M017605;
        Tue, 25 Feb 2020 04:30:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=6LRoatBMTxXw8lh0DTeuhi95XzhJ+fjePvgP5bFJ7uY=;
 b=xZVjBmYO6S44wY9zSmsxS2GgeLQ+gMTpvnoEIKffgK5fygMcAs//zmSnPc0BwUyylzUN
 4jnhQCkcYeZEu+Y7Laz+eF7GovTK5yfIVcciZuEXKVd4hJKpzNwFj8Jb7ZcBESp5ENWC
 7GXtQlXGCPx9Da/sC+cZsrkepNz+n+putLgciGN0l/AQWialutAIrvo6jcvig5RNygMw
 dOIWLpMXgE+kqIh3pXgUpI4rJ3rt9cVRaw9rsiDhjnzf6XAqnzUiK3jY+AUUrY9TbPRv
 zuFJ1B3ElHwOk9GCBhUV1cLCvtf03APmddO/lgbkxGyb+Sw8KLuhi3e2NxCS8BcAn0uj xA== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0b-002c1b01.pphosted.com with ESMTP id 2yb4gmp3wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Feb 2020 04:30:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nt0xikppXpqNEqslBVCQ5VNFgghOPbsj+3GN6SuJ5kPyPx44gMkR9azSwp+w8giqPDABGNmh0xi+nFLp/SzzWMQpeY60pKc+3Ns79v2b+RY/fdxXpodzcuMDjB2Wx4XqnfBCMpCi98l5vM2iNoyHAQpxemCWsFyI6KM/vtwE6pKcmnQu8o6hq8PyStjIUs62kYEgsKW2yCalvk2zV3f56Ltm+u20d1/jogEepicLIGvKSk4LzYmUI+vNu/1JQ012u9g58d6wup+M4dJsbQxBCMq2g4qa83OQzZJidDiOEWZYwqgxCgaLZVmOr3s0CZ0dpm6P2oOuvRXes58lDkIyGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LRoatBMTxXw8lh0DTeuhi95XzhJ+fjePvgP5bFJ7uY=;
 b=YiExhT6i8AKl3cYcK4KCmCmFTKIxAeCTBNAtptNh7G0kXKzSG5bYBuWn2DFsRTiHUb/PW+xcWU2l9shYXzof8aRNZEwgdcOLkLz+pjes0oAbv55R841q/GUMAHRNLL6d+6HtdurZ5SWiDAV+wfAz/tFZie5mE+t8uVFVP+8yAll+oF5ilqaR8qrqK7+5NSHRGsgIwM0Ybd3jt1s7xMY8yFiMSGDrZu2G7K1YqheQUR9HOVB+zvIOTO0/erBbxe7tbHLiPleq/oOqXrYQ7bLxToIhzTFJsgZGozvx1a6bVTcsslIrTwAFXDvoDAFAdPfT5vVFBueW0gn7cdSKkz3jQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from MWHPR02MB2656.namprd02.prod.outlook.com (2603:10b6:300:45::14)
 by MWHPR02MB2509.namprd02.prod.outlook.com (2603:10b6:300:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Tue, 25 Feb
 2020 12:30:17 +0000
Received: from MWHPR02MB2656.namprd02.prod.outlook.com
 ([fe80::c4c8:b406:7827:8a2b]) by MWHPR02MB2656.namprd02.prod.outlook.com
 ([fe80::c4c8:b406:7827:8a2b%6]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 12:30:17 +0000
From:   Felipe Franciosi <felipe@nutanix.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "slp@redhat.com" <slp@redhat.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        "robert.bradford@intel.com" <robert.bradford@intel.com>,
        Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Thread-Topic: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Thread-Index: AQHV6b17a68gHQDa0EyXI0dJY95wc6gr2EuAgAAC5AA=
Date:   Tue, 25 Feb 2020 12:30:16 +0000
Message-ID: <72104184-234B-4233-AC9D-3C54B1752F7F@nutanix.com>
References: <20200222201916.GA1763717@stefanha-x1.localdomain>
 <62FEFA1E-0D75-4AFB-860A-59CF5B9B45F7@nutanix.com>
In-Reply-To: <62FEFA1E-0D75-4AFB-860A-59CF5B9B45F7@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [62.254.189.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce4e8226-c66a-4dde-1097-08d7b9ee78ed
x-ms-traffictypediagnostic: MWHPR02MB2509:
x-microsoft-antispam-prvs: <MWHPR02MB2509813652889CF30475620DD7ED0@MWHPR02MB2509.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(186003)(36756003)(6916009)(26005)(2616005)(6506007)(91956017)(76116006)(66556008)(66476007)(53546011)(6486002)(64756008)(6512007)(86362001)(66446008)(66946007)(4326008)(478600001)(54906003)(7416002)(5660300002)(316002)(30864003)(33656002)(81166006)(2906002)(8676002)(81156014)(8936002)(71200400001)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR02MB2509;H:MWHPR02MB2656.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nutanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iFhzGJ3HAcXq9lqVqtLzlT1uqIyJHAeCFJuwWxtcpWX+jbW21xzGPivP4MgABNVBF6mClPAOt2FQWWcgWTbQZEMBZcx8kilqHM75MGTswSQBBjwTusfY05oyOt4e12cXPpIv+hEUjY501DPwxmGIKug3xmt6PTrZFNitgtzmJhWBCO8MMxbjqekL3D+FwcB/d4mhdWeLUC3lZTpw1wH2E0Ebf11l3+nsUC0exKD1v6qE+iBVv0xRt9zL1PUCI1bnB8fEshzv+UTAlvFka007jHicbTDGWb3bT5Ma8a9T34G2r6OAW9LlZMkYWmDjmxhjhDfSozOS0r6VC/Jp10iMN2BDvoj+UKf54oJq6Tsewiqis/e6v/BLXpEdrw1vuXSX8kFtQ9mrHVJwXugoXt1Ro1jpHpbNC7ljUQtT/7EztqUParY1icA/t9DRuloSFNSLviKUA1DtrKspDz/T7vjmseqoZnweqJpGcIVzx7Olj/PDJAMMT9MFvaSX1S45gPI3
x-ms-exchange-antispam-messagedata: f6yWBn+3kagi+ybFeURV25HkzwbQerrl824GgPthyYJJ6zSYIZucpr9U9lHpEEfbUl5p1Vu+CS7C2gntopR+EoRlaCFaQTMwUoiznkEoE0L8MWPsx4eABXvNYsStyApROZhjvSwgqYhgyqC0bXW+vg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C045BD32BCE6AD49B33A434CC1E2E732@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4e8226-c66a-4dde-1097-08d7b9ee78ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 12:30:17.0275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OSxUBWx6KmwLhPkLd83UnvI43Kkbj8HUg8V9kxcXYpIuoAsM6UUTZ8kOdwHMmKKwP81ExNhuS3/H+X0aV6NEBpuKx1GkhFQCRB8s18HEZrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2509
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_03:2020-02-21,2020-02-25 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ah, I forgot to ask a few other questions.

> On Feb 25, 2020, at 12:19 PM, Felipe Franciosi <felipe@nutanix.com> wrote=
:
>=20
> Hi,
>=20
> This looks amazing, Stefan. The lack of such a mechanism troubled us
> during the development of MUSER and resulted in the slow-path we have
> today for MMIO with register semantics (when writes cannot be
> overwritten before the device emulator has a chance to process them).
>=20
> I have added some comments inline, but wanted to first link your
> proposal with an idea that I discussed with Maxim Levitsky back in
> Lyon and evolve on it a little bit. IIRC/IIUC Maxim was keen on a VT-x
> extension where a CPU could IPI another to handle events which would
> normally cause a VMEXIT. That is probably more applicable to the
> standard ioeventfd model, but it got me thinking about PML.
>=20
> Bear with me. :)
>=20
> In addition to an fd, which could be used for notifications only, the
> wire protocol could append "struct ioregionfd_cmd"s (probably renamed
> to drop "fd") to one or more pages (perhaps a ring buffer of sorts).
>=20
> That would only work for writes; reads would still be synchronous.
>=20
> The device emulator therefore doesn't have to respond to each write
> command. It could process the whole lot whenever it gets around to it.
> Most importantly (and linking back to the VT-x extension idea), maybe
> we can avoid the VMEXIT altogether if the CPU could take care of
> appending writes to that buffer. Thoughts?
>=20
>> On Feb 22, 2020, at 8:19 PM, Stefan Hajnoczi <stefanha@redhat.com> wrote=
:
>>=20
>> Hi,
>> I wanted to share this idea with the KVM community and VMM developers.
>> If this isn't relevant to you but you know someone who should
>> participate, please feel free to add them :).
>>=20
>> The following is an outline of "ioregionfd", a cross between ioeventfd
>> and KVM memory regions.  This mechanism would be helpful for VMMs that
>> emulate devices in separate processes, muser/VFIO, and to address
>> existing use cases that ioeventfd cannot handle.
>>=20
>> Background
>> ----------
>> There are currently two mechanisms for dispatching MMIO/PIO accesses in
>> KVM: returning KVM_EXIT_MMIO/KVM_EXIT_IO from ioctl(KVM_RUN) and
>> ioeventfd.  Some VMMs also use polling to avoid dispatching
>> performance-critical MMIO/PIO accesses altogether.
>>=20
>> These mechanisms have shortcomings for VMMs that perform device
>> emulation in separate processes (usually for increased security):
>>=20
>> 1. Only one process performs ioctl(KVM_RUN) for a vCPU, so that
>>  mechanism is not available to device emulation processes.
>>=20
>> 2. ioeventfd does not store the value written.  This makes it unsuitable
>>  for NVMe Submission Queue Tail Doorbell registers because the value
>>  written is needed by the device emulation process, for example.
>>  ioeventfd also does not support read operations.
>>=20
>> 3. Polling does not support computed read operations and only the latest
>>  value written is available to the device emulation process
>>  (intermediate values are overwritten if the guest performs multiple
>>  accesses).
>>=20
>> Overview
>> --------
>> This proposal aims to address this gap through a wire protocol and a new
>> KVM API for registering MMIO/PIO regions that use this alternative
>> dispatch mechanism.
>>=20
>> The KVM API is used by the VMM to set up dispatch.  The wire protocol is
>> used to dispatch accesses from KVM to the device emulation process.
>>=20
>> This new MMIO/PIO dispatch mechanism eliminates the need to return from
>> ioctl(KVM_RUN) in the VMM and then exchange messages with a device
>> emulation process.
>>=20
>> Inefficient dispatch to device processes today:
>>=20
>>  kvm.ko  <---ioctl(KVM_RUN)---> VMM <---messages---> device
>>=20
>> Direct dispatch with the new mechanism:
>>=20
>>  kvm.ko  <---ioctl(KVM_RUN)---> VMM
>>    ^
>>    `---new MMIO/PIO mechanism-> device
>>=20
>> Even single-process VMMs can take advantage of the new mechanism.  For
>> example, QEMU's emulated NVMe storage controller can implement IOThread
>> support.
>>=20
>> No constraint is placed on the device process architecture.  A single
>> process could emulate all devices belonging to the guest, each device
>> could be its own process, or something in between.
>>=20
>> Both ioeventfd and traditional KVM_EXIT_MMIO/KVM_EXIT_IO emulation
>> continue to work alongside the new mechanism, but only one of them is
>> used for any given guest address.
>>=20
>> KVM API
>> -------
>> The following new KVM ioctl is added:
>>=20
>> KVM_SET_IOREGIONFD
>> Capability: KVM_CAP_IOREGIONFD
>> Architectures: all
>> Type: vm ioctl
>> Parameters: struct kvm_ioregionfd (in)
>> Returns: 0 on success, !0 on error
>>=20
>> This ioctl adds, modifies, or removes MMIO or PIO regions where guest
>> accesses are dispatched through a given file descriptor instead of
>> returning from ioctl(KVM_RUN) with KVM_EXIT_MMIO or KVM_EXIT_PIO.
>>=20
>> struct kvm_ioregionfd {
>>   __u64 guest_physical_addr;
>>   __u64 memory_size; /* bytes */
>>   __s32 fd;
>>   __u32 region_id;
>>   __u32 flags;
>>   __u8  pad[36];
>> };
>>=20
>> /* for kvm_ioregionfd::flags */
>> #define KVM_IOREGIONFD_PIO           (1u << 0)
>> #define KVM_IOREGIONFD_POSTED_WRITES (1u << 1)
>>=20
>> Regions are deleted by passing zero for memory_size.
>>=20
>> MMIO is the default.  The KVM_IOREGIONFD_PIO flag selects PIO instead.
>>=20
>> The region_id is an opaque token that is included as part of the write
>> to the file descriptor.  It is typically a unique identifier for this
>> region but KVM does not interpret its value.
>>=20
>> Both read and write guest accesses wait until an acknowledgement is
>> received on the file descriptor.  The KVM_IOREGIONFD_POSTED_WRITES flag
>> skips waiting for an acknowledgement on write accesses.  This is
>> suitable for accesses that do not require synchronous emulation, such as
>> doorbell register writes.
>>=20
>> Wire protocol
>> -------------
>> The protocol spoken over the file descriptor is as follows.  The device
>> reads commands from the file descriptor with the following layout:
>>=20
>> struct ioregionfd_cmd {
>>   __u32 info;
>>   __u32 region_id;
>>   __u64 addr;
>>   __u64 data;
>>   __u8 pad[8];
>> };
>>=20
>> /* for ioregionfd_cmd::info */
>> #define IOREGIONFD_CMD_MASK 0xf
>> # define IOREGIONFD_CMD_READ 0
>> # define IOREGIONFD_CMD_WRITE 1
>=20
> Why do we need 4 bits for this? I appreciate you want to align the
> next field, but there's SIZE_SHIFT for that; you could have CMD_MASK
> set to 0x1 unless I'm missing something. The reserved space could be
> used for something else in the future.
>=20
>> #define IOREGIONFD_SIZE_MASK 0x30
>> #define IOREGIONFD_SIZE_SHIFT 4
>> # define IOREGIONFD_SIZE_8BIT 0
>> # define IOREGIONFD_SIZE_16BIT 1
>> # define IOREGIONFD_SIZE_32BIT 2
>> # define IOREGIONFD_SIZE_64BIT 3
>=20
> Christophe already asked about the 64-bit limit. I think that's fine,
> and am assuming that if larger accesses are ever needed they can just
> be split in two commands by KVM?
>=20
>> #define IOREGIONFD_NEED_PIO (1u << 6)
>> #define IOREGIONFD_NEED_RESPONSE (1u << 7)
>>=20
>> The command is interpreted by inspecting the info field:
>>=20
>> switch (cmd.info & IOREGIONFD_CMD_MASK) {
>> case IOREGIONFD_CMD_READ:
>>     /* It's a read access */
>>     break;
>> case IOREGIONFD_CMD_WRITE:
>>     /* It's a write access */
>>     break;
>> default:
>>     /* Protocol violation, terminate connection */
>> }
>>=20
>> The access size is interpreted by inspecting the info field:
>>=20
>> unsigned size =3D (cmd.info & IOREGIONFD_SIZE_MASK) >> IOREGIONFD_SIZE_S=
HIFT;
>> /* where nbytes =3D pow(2, size) */
>>=20
>> The region_id indicates which MMIO/PIO region is being accessed.  This
>> field has no inherent structure but is typically a unique identifier.
>>=20
>> The byte offset being accessed within that region is addr.
>=20
> It's not clear to me if addr is GPA absolute or an offset. Sounds like
> the latter, in which case isn't it preferable to name this "offset"?
>=20
>>=20
>> If the command is IOREGIONFD_CMD_WRITE then data contains the value
>> being written.
>>=20
>> MMIO is the default.  The IOREGIONFD_NEED_PIO flag is set on PIO
>> accesses.
>>=20
>> When IOREGIONFD_NEED_RESPONSE is set on a IOREGIONFD_CMD_WRITE command,
>> no response must be sent.  This flag has no effect for
>> IOREGIONFD_CMD_READ commands.
>=20
> Christophe already flagged this, too. :)
>=20
> That's all I had for now.
>=20
> F.
>=20
>>=20
>> The device sends responses by writing the following structure to the
>> file descriptor:
>>=20
>> struct ioregionfd_resp {
>>   __u64 data;
>>   __u32 info;
>>   __u8 pad[20];
>> };
>>=20
>> /* for ioregionfd_resp::info */
>> #define IOREGIONFD_RESP_FAILED (1u << 0)
>>=20
>> The info field is zero on success.  The IOREGIONFD_RESP_FAILED flag is
>> set on failure.
>>=20
>> The data field contains the value read by an IOREGIONFD_CMD_READ
>> command.  This field is zero for other commands.
>>=20
>> Does it support polling?
>> ------------------------
>> Yes, use io_uring's IORING_OP_READ to submit an asynchronous read on the
>> file descriptor.  Poll the io_uring cq ring to detect when the read has
>> completed.
>>=20
>> Although this dispatch mechanism incurs more overhead than polling
>> directly on guest RAM, it overcomes the limitations of polling: it
>> supports read accesses as well as capturing written values instead of
>> overwriting them.
>>=20
>> Does it obsolete ioeventfd?
>> ---------------------------
>> No, although KVM_IOREGIONFD_POSTED_WRITES offers somewhat similar
>> functionality to ioeventfd, there are differences.  The datamatch
>> functionality of ioeventfd is not available and would need to be
>> implemented by the device emulation program.  Due to the counter
>> semantics of eventfds there is automatic coalescing of repeated accesses
>> with ioeventfd.  Overall ioeventfd is lighter weight but also more
>> limited.
>>=20
>> How does it scale?
>> ------------------
>> The protocol is synchronous - only one command/response cycle is in
>> flight at a time.  The vCPU will be blocked until the response has been
>> processed anyway.  If another vCPU accesses an MMIO or PIO region with
>> the same file descriptor during this time then it will wait to.

What happens if a vCPU issues an MMIO read access and the kernel task
is blocked reading from the fd, but the userspace counterpart does not resp=
ond?

Would the vCPU still respond to SIGIPIs if blocked?

What implications do you see or thoughts do you have for live migration?

Cheers,
Felipe

>>=20
>> In practice this is not a problem since per-queue file descriptors can
>> be set up for multi-queue devices.
>>=20
>> It is up to the device emulation program whether to handle multiple
>> devices over the same file descriptor or not.
>>=20
>> What exactly is the file descriptor (e.g. eventfd, pipe, char device)?
>> ----------------------------------------------------------------------
>> Any file descriptor that supports bidirectional I/O would do.  This
>> rules out eventfds and pipes.  socketpair(AF_UNIX) is a likely
>> candidate.  Maybe a char device will be necessary for improved
>> performance.
>>=20
>> Can this be part of KVM_SET_USER_MEMORY_REGION?
>> -----------------------------------------------
>> Maybe.  Perhaps everything can be squeezed into struct
>> kvm_userspace_memory_region but it's only worth doing if the memory
>> region code needs to be reused for this in the first place.  I'm not
>> sure.
>>=20
>> What do you think?
>> ------------------
>> I hope this serves as a starting point for improved MMIO/PIO dispatch in
>> KVM.  There are no immediate plans to implement this but I think it will
>> become necessary within the next year or two.
>>=20
>> 1. Does it meet your requirements?
>> 2. Are there better alternatives?
>>=20
>> Thanks,
>> Stefan
>=20

