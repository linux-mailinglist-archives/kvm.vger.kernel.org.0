Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877944981F1
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 15:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbiAXOVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 09:21:16 -0500
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:35169
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233777AbiAXOVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 09:21:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GcvVKueUPPWd3317PskEPp1TPQEPoNYiPRxkQGq7nkmfyB6KyZ+7EQyiIIcL1KpSUiFu/wZzkBdh8+njALqrwOClRzWJv5IB6ed5apdJMGBGHCueAJOsBboXiW2ZNWU3g86c4T+NcEK13obcang5WoB75R274Ctc2BEZTvgKcKnNxKqvWFeN1Nvg0jNf+tiD9ve3QwJXBfw8BbGfNLO8KElF95GgS5a2embqWsERVwoSE/JB4LntDuIMhy6HPwYSGhp0dsTopsAWh8pMUKfjmhEg1cc9+LitTo9XkBB/spOcG2CBo3jt74Wxf7+HbkH8Prt7512w0cf0FPH9C6HP8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34RXcdeqhKSl/M212jErLufedHiugAI1UHh1hFDVDso=;
 b=EUAPUmkqLSG9YgAFXM5uB0/jLpT+L/sro17MGRnfhmGqLKcE3Nbrfe3NxI1uP+ndi8opGgV8dwwhxnynabOu34h7lMPIDlNfNNkbIEnT7+6CWBFoFXx87z/VNOn17U246gFQ/ul1G1sLE0oaM0MPrp9ierKb+mejOqnI1YE4e8GlHjRDHD4Z63EMjFdBCqF8Hyp5cu8J/bwmP+02mjJH4jGQErRfC9DVUrA/d72oYJfrKWYF4Jy3Yje9LBwf3p5eKUKTdMq6cpzyi/k/E9L++3Gwl1r01hcIYh03OkET3osUsg1uw2WJocpOaFfTxIep1p0peKulHlI3qpjQaQTWAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34RXcdeqhKSl/M212jErLufedHiugAI1UHh1hFDVDso=;
 b=J724V+Dd0ur0gQxN26ymv6/6/Vj8Jvcs/sqvRISYaRwAiE72IaM5x5PRxC3liOiwGgW+74XyOeaIKBqCWdQkpBikfcCZBapzz4djD4F6F5tOOzn1HtdT2ViXBrqoHjM9k5dIz76kRUb/noRQj8X6clTAFrigYAvgrPqTStKRO/g=
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by BN9PR12MB5195.namprd12.prod.outlook.com (2603:10b6:408:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Mon, 24 Jan
 2022 14:21:11 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::b07d:3a18:d06d:cb0b]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::b07d:3a18:d06d:cb0b%4]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 14:21:11 +0000
From:   "Lazar, Lijo" <Lijo.Lazar@amd.com>
To:     James Turner <linuxkernel.foss@dmarc-none.turner.link>
CC:     Alex Deucher <alexdeucher@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Thread-Topic: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Thread-Index: AQHYDo+lzAdL4BCVWUC/DLCLGS2ze6xtr4mAgACHo4CAAFNgYIABAYCAgAKvjdA=
Date:   Mon, 24 Jan 2022 14:21:11 +0000
Message-ID: <BYAPR12MB4614E2CFEDDDEAABBAB986A0975E9@BYAPR12MB4614.namprd12.prod.outlook.com>
References: <87ee57c8fu.fsf@turner.link>
 <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
 <87a6ftk9qy.fsf@dmarc-none.turner.link> <87zgnp96a4.fsf@turner.link>
 <fc2b7593-db8f-091c-67a0-ae5ffce71700@leemhuis.info>
 <CADnq5_Nr5-FR2zP1ViVsD_ZMiW=UHC1wO8_HEGm26K_EG2KDoA@mail.gmail.com>
 <87czkk1pmt.fsf@dmarc-none.turner.link>
 <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87sftfqwlx.fsf@dmarc-none.turner.link>
In-Reply-To: <87sftfqwlx.fsf@dmarc-none.turner.link>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-24T14:20:55Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=18d65763-0318-4e86-85cd-1cdd7a355da1;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-24T14:21:08Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 1ecf78f0-f5f8-4aeb-b712-061d4725b5a0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c54190e-7c10-4d41-32f5-08d9df44c5bc
x-ms-traffictypediagnostic: BN9PR12MB5195:EE_
x-microsoft-antispam-prvs: <BN9PR12MB519578979EA0D635CCB1ADEA975E9@BN9PR12MB5195.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: smFnBKetHSE3LLfn9JbdoWU2tXUV0ljSnYCqtsUNOU3By1YfHmznpC3IjGXRlltNig7qlmm42YCFPieI6EUqjDIXNo1F7mxYI6koMcqQtq2LMBSuF63QjNfjNYVDEBlnlVKJXtnsT24C4Ou3EKmUawQK5VhBoC8tKLAxdI6PsZIhWzZ09GVv5R+TTbckELwh5ExNwF6qjboWRQgrTvBkkAbbnIf+7cO48m1aquR0phqt2rxpNhWr26m1M/aK4fYNwNQHOotEKA4TQWj/ysLKcUEf1OSrp59SCm/xMYqa3aQl1wo9wF9J37fVra+NihZ3LCokqDjyPA4Scl2Z4GzA7a6hIscNEW/ndmqgYQmDHFSw8RF9e3shXSFi/mQI9V3ygfa1Lti6RR8c6cujFnOeLe0FhjIEqCbXx3yirT4C+GhVKnk8duChA+EO0+WOl8Ho4D2KhmEr2YuaTzDSwolkhH59nLaA0CBc0crHOnrhdOg1ZwLXrpQA9r4Cp8qo1vEgh4omze0/iJjAMkfmKA1D6n7IYNOLNwu94Y/SYqjhcG1f6I9UectJp2REfibMx7vUIaS9BaLKoD7wD/oDmq8Y87YpaJMjjoLmq8Z8ikuwHUv+Bkn2SkG5AbQzD25tDHSO2r2ddaECq4WiYdRV6cQkmfsFEfOoMbNF2uVQoYREx2DK7VotQlAQFz5J/bd3E3e3GdquSs6YbSRkVs33xV5E5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(71200400001)(33656002)(26005)(66946007)(4326008)(54906003)(66446008)(55016003)(38100700002)(6916009)(7696005)(76116006)(52536014)(86362001)(122000001)(66556008)(8936002)(64756008)(508600001)(186003)(8676002)(38070700005)(6506007)(53546011)(83380400001)(5660300002)(2906002)(316002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hNbOQ/MDDPosiUSkORbLBGtFYCkpHzSHFaeOjYu7/jBEAHw2Z1yPHFPrE48u?=
 =?us-ascii?Q?6NkjP/Hjm+ED/OKMVVcpAwSF0FQzwveEfzmAK70aPmDmf3M23UYZ/yKt+XXb?=
 =?us-ascii?Q?r0e3CCZLSEUeA57fgd/HCxVlQ6l0MHe29vc8KVYaq6hYAuXopF5/GFlTgTiS?=
 =?us-ascii?Q?2ERd4LrElg67zX4HtrEGCqtGgUoxgodoX8H9fDsrtfhEpULNpICOnnY1cztx?=
 =?us-ascii?Q?Bl5Z29dqIX3GTi1/osky7ZrpCNJe4FMsvkNbKixj131QdMwIU8+JQFOdD7+c?=
 =?us-ascii?Q?VBBOa8GNYeA0o96sJyibEIj57v60D4850QXqNH/qkvp3hIXzSTOo2LYhkqNh?=
 =?us-ascii?Q?uDFGDAc/1QkX1WDzRY9Rth9jh20Qom1UCplWTKM2yLqgvamgnfzC+7VC7waY?=
 =?us-ascii?Q?Yr9jc0mRmv2/85UTL6RwHueCoJc44v4JzzNR2BEUampdmnqGrpMkEMD8rVzU?=
 =?us-ascii?Q?xbT75kNMoMtOLmah3KHj2gKtsG81fSfQm7yco+/90bQS6SCntT5ZDFrxKsEM?=
 =?us-ascii?Q?LDe89RigN6PVAcd/+HkgAL6rWJpwvUaO3RPSgIrpm5xQldPRkwyZMudKAlcn?=
 =?us-ascii?Q?xfRMi1kut0s3yD5QBeKi5a9cIdhNKISmj7NF0y+G2jRPGCeHWAq111oEMcZq?=
 =?us-ascii?Q?hCjMTICC8rW7EWSIe3ZITDOmxg8xNQxZDLXxrGmhWRi4d+T5Deps1iwyoAvt?=
 =?us-ascii?Q?cuF81TpGVGso+5PB1jI9MdjBkgxSdDokljGGNklNsGkq9ba0FklvisnetS6k?=
 =?us-ascii?Q?MGPpud24NJ1YGmpfCigadJKdcLPwXwL5Y0noHkvtCxOG+txE/il/thNkPVVs?=
 =?us-ascii?Q?RNHBKzyDbXtIG9pREhpm7mH+WdyLvWIwUdmJRVId5HJAaKlO4calPY7vE/ND?=
 =?us-ascii?Q?QshFp7k/tiaX9gmsZKP3m7GwJxNDfvOU1Dh9uuI6YbHW5AgaLlYeEbvL7stQ?=
 =?us-ascii?Q?FAqkeO3oQzQq8sv4WQX55p10ON1UwVqjVU3gZ9M+oLVgs68Cft0URMl2IApJ?=
 =?us-ascii?Q?WIMRww/TramAAPYrneDkW5vmVxEVJxETTix21N/30zUMoLQuCXYPn3tJibtj?=
 =?us-ascii?Q?OLxrC4i08uLn6JWTyb/bjE5ZVWptYzTDkbX9s4jUIuzatDkqULPxQCOl3Eyh?=
 =?us-ascii?Q?GCSNSKpFfqymLAwINUvnTHuetjPdT068RBDbn2CTW+fnsISpWLvssdF+Tk41?=
 =?us-ascii?Q?L9u0QXuqOkJAtDniDeGEBtsyCJDKLY1cCXHgW0ILy0D4V6i415T9LMDXZUQh?=
 =?us-ascii?Q?2QYdoxJltiEXuYhP+MB7NHk/29jTdNN7E3TgRDVwJwjngEx1v/PJv6p85efc?=
 =?us-ascii?Q?BFsdOz7V1rJwkyG1rDuNtTi3yKJmlq0DkpMCGQpdhnhWZTe+fdsGfTzmhB/2?=
 =?us-ascii?Q?GfUxyWA9UwoYhcXbUAd0EoVIYfz8tUOhkUdRiQJEyTcfvliqMlxZVQPXY9gU?=
 =?us-ascii?Q?197e6guxs38gL9roO28Zk5yFmXhGMfkv4KVm4C9tlrakl++Eh1lYuYkLGXM9?=
 =?us-ascii?Q?QXJx/0Sjqunt8mgOJWMhE00P9toTp6Fih2F5jc8U5zwNfI+bDpmBLahnKehk?=
 =?us-ascii?Q?4q+oybWjs3zlYfErJfg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c54190e-7c10-4d41-32f5-08d9df44c5bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 14:21:11.5820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f99NYWWcDb9ZDQ8fpKgrfd7OQpEJYSEfjgTqTpkAOdd658wnli18rUPLKxcoutz3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5195
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Public]

Not able to relate to how it affects gfx/mem DPM alone. Unless Alex has oth=
er ideas, would you be able to enable drm debug messages and share the log?

	Enabling verbose debug messages is done through the drm.debug parameter, e=
ach category being enabled by a bit:

	drm.debug=3D0x1 will enable CORE messages
	drm.debug=3D0x2 will enable DRIVER messages
	drm.debug=3D0x3 will enable CORE and DRIVER messages
	...
	drm.debug=3D0x1ff will enable all messages
	An interesting feature is that it's possible to enable verbose logging at =
run-time by echoing the debug value in its sysfs node:

	# echo 0xf > /sys/module/drm/parameters/debug

Thanks,
Lijo

-----Original Message-----
From: James Turner <linuxkernel.foss@dmarc-none.turner.link>=20
Sent: Sunday, January 23, 2022 2:41 AM
To: Lazar, Lijo <Lijo.Lazar@amd.com>
Cc: Alex Deucher <alexdeucher@gmail.com>; Thorsten Leemhuis <regressions@le=
emhuis.info>; Deucher, Alexander <Alexander.Deucher@amd.com>; regressions@l=
ists.linux.dev; kvm@vger.kernel.org; Greg KH <gregkh@linuxfoundation.org>; =
Pan, Xinhui <Xinhui.Pan@amd.com>; LKML <linux-kernel@vger.kernel.org>; amd-=
gfx@lists.freedesktop.org; Alex Williamson <alex.williamson@redhat.com>; Ko=
enig, Christian <Christian.Koenig@amd.com>
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU PCI-passed-th=
rough to Windows VM

Hi Lijo,

> Could you provide the pp_dpm_* values in sysfs with and without the=20
> patch? Also, could you try forcing PCIE to gen3 (through pp_dpm_pcie)=20
> if it's not in gen3 when the issue happens?

AFAICT, I can't access those values while the AMD GPU PCI devices are bound=
 to `vfio-pci`. However, I can at least access the link speed and width els=
ewhere in sysfs. So, I gathered what information I could for two different =
cases:

- With the PCI devices bound to `vfio-pci`. With this configuration, I
  can start the VM, but the `pp_dpm_*` values are not available since
  the devices are bound to `vfio-pci` instead of `amdgpu`.

- Without the PCI devices bound to `vfio-pci` (i.e. after removing the
  `vfio-pci.ids=3D...` kernel command line argument). With this
  configuration, I can access the `pp_dpm_*` values, since the PCI
  devices are bound to `amdgpu`. However, I cannot use the VM. If I try
  to start the VM, the display (both the external monitors attached to
  the AMD GPU and the built-in laptop display attached to the Intel
  iGPU) completely freezes.

The output shown below was identical for both the good commit:
f1688bd69ec4 ("drm/amd/amdgpu:save psp ring wptr to avoid attack") and the =
commit which introduced the issue:
f9b7f3703ff9 ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)")

Note that the PCI link speed increased to 8.0 GT/s when the GPU was under h=
eavy load for both versions, but the clock speeds of the GPU were different=
 under load. (For the good commit, it was 1295 MHz; for the bad commit, it =
was 501 MHz.)


# With the PCI devices bound to `vfio-pci`

## Before starting the VM

% ls /sys/module/amdgpu/drivers/pci:amdgpu
module  bind  new_id  remove_id  uevent  unbind

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -pr=
int -exec cat {} \; /sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
8.0 GT/s PCIe

## While running the VM, before placing the AMD GPU under heavy load

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -pr=
int -exec cat {} \; /sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
2.5 GT/s PCIe

## While running the VM, with the AMD GPU under heavy load

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -pr=
int -exec cat {} \; /sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
8.0 GT/s PCIe

## While running the VM, after stopping the heavy load on the AMD GPU

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -pr=
int -exec cat {} \; /sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
2.5 GT/s PCIe

## After stopping the VM

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -pr=
int -exec cat {} \; /sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
2.5 GT/s PCIe


# Without the PCI devices bound to `vfio-pci`

% ls /sys/module/amdgpu/drivers/pci:amdgpu
0000:01:00.0  module  bind  new_id  remove_id  uevent  unbind

% for f in /sys/module/amdgpu/drivers/pci:amdgpu/*/pp_dpm_*; do echo "$f"; =
cat "$f"; echo; done /sys/module/amdgpu/drivers/pci:amdgpu/0000:01:00.0/pp_=
dpm_mclk
0: 300Mhz
1: 625Mhz
2: 1500Mhz *

/sys/module/amdgpu/drivers/pci:amdgpu/0000:01:00.0/pp_dpm_pcie
0: 2.5GT/s, x8
1: 8.0GT/s, x16 *

/sys/module/amdgpu/drivers/pci:amdgpu/0000:01:00.0/pp_dpm_sclk
0: 214Mhz
1: 501Mhz
2: 850Mhz
3: 1034Mhz
4: 1144Mhz
5: 1228Mhz
6: 1275Mhz
7: 1295Mhz *

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -pr=
int -exec cat {} \; /sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
8.0 GT/s PCIe


James
