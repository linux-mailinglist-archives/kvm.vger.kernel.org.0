Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701C831E0AC
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 21:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhBQUoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 15:44:39 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1655 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbhBQUog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 15:44:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602d80090001>; Wed, 17 Feb 2021 12:43:53 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Feb
 2021 20:43:49 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Feb
 2021 20:42:00 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 17 Feb 2021 20:42:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8RB598XcnW6YLV/S5LOPhOGtRcBYk+lCQelJR2s3Y+PRCUzho59RoR/NIC/y6Cs+rYvucTeSY87zv5oA3L4l6fr7+yThpy5sb6tAi5NTbTnWL9mWak45JAJak3eUhEsEQSgNPiFII38GXJF8yONnpBxI1+SIDiQUDmUWnWtwh8S8lT07XZFs15UlXm/qmb0riY5p2QlDr7j7+2dP+ZudXJb5Q4Hwjudqk+CF7rP5xhohQN4TlVfuz6S3X6nIvugo0Ij7Pg3+Hc4GvGEl6r9s1pBRNdCAEQ50EqyC/NasHEbuzL3+y30h9Ua3RFQrxBt34ljjj/3qj3XG4nFIi6j5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bYTY+6odKpJu+U+yoItoHG/H9pBhSw7VNp1twJQ/lI=;
 b=W9vtQ4RAVIypLzUkq3GSSSA+VRXIOA8osxbScw87/DLCn4UmcRa4MCWENBUdojiTRc7uB7KucHJ0OMY7Q2Q457TmShl6SPv6caQv/z7kQ51CttG3I4nZSEIK6PYTL80BuSe2GO5zycmnP55AHqjIR0zbMGC4XLtWUGfbKnrfRrOnI30uXlklatH3+u2JrLH7IfCcgRihwWHGmOlxqlTHBRrrgE0zm2TGk/E2JbOolgRIHMXJloGxwYbNy0vZB+rcGhJVvfjrObNzDt8aPY0+89gm5we2FLN1pok/csQp0FyW3vtP3MTgmW2c6gDBFBvzEg0lSkafNUOhvvEluluh0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM6PR12MB4121.namprd12.prod.outlook.com (2603:10b6:5:220::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 17 Feb
 2021 20:41:58 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::99ad:984a:7f84:be07]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::99ad:984a:7f84:be07%6]) with mapi id 15.20.3846.039; Wed, 17 Feb 2021
 20:41:58 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Somdutta Roy" <somduttar@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>
Subject: RE: Optimized clocksource with AMD AVIC enabled for Windows guest
Thread-Topic: Optimized clocksource with AMD AVIC enabled for Windows guest
Thread-Index: Adb59oEjzgg4QSxwQnWgWIvDOxc3GgAC+LyAAAKxoIAAIPt5EAAX5X8AAAJ4aAAAAwABAAAAokaAABmP/vAA9NYmEA==
Date:   Wed, 17 Feb 2021 20:41:58 +0000
Message-ID: <DM6PR12MB3500EE1617B84D62784AC681CA869@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
 <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
 <878s85pl4o.fsf@vitty.brq.redhat.com>
 <DM6PR12MB35006123BF3E9D8B67042CC9CAB39@DM6PR12MB3500.namprd12.prod.outlook.com>
 <87zh0knhqb.fsf@vitty.brq.redhat.com>
 <721b7075-6931-80f1-7b28-fc723ad14c13@redhat.com>
 <87wnvnop1p.fsf@vitty.brq.redhat.com> <87tuqroo7g.fsf@vitty.brq.redhat.com>
 <DM6PR12MB350095499FBD665AA7D969A2CAB29@DM6PR12MB3500.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB350095499FBD665AA7D969A2CAB29@DM6PR12MB3500.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Enabled=True;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SiteId=43083d15-7273-40c1-b7db-39efd9ccc17a;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Owner=kechenl@nvidia.com;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SetDate=2021-02-05T05:38:31.8843857Z;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Name=Unrestricted;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Extended_MSFT_Method=Automatic;
 Sensitivity=Unrestricted
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [216.228.112.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccdc217c-e250-4367-e967-08d8d3847889
x-ms-traffictypediagnostic: DM6PR12MB4121:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB4121FCB3B1ACFF4C89612124CA869@DM6PR12MB4121.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v+neQZoC3WjN1P9lqyyILDy0oryq7UuWl37aBcTuG/IT6bXMFGgJjl7L+qI5uSz8fkSO5fm4uLDaB22zq9CaKUQcK8ZzlDaBMlXG/lLNjtzZ8ZXBEF4lQVqbjv4mqJtbU8OiA0jq1zYFIU9gNzQ/1tt4XCS2Pv8Fh4IxoCQvwBTCNJwA2fp4Y6A0xrl/PdX+vfGj5qNLnANfEkUgG+KZ1A7VYrWtNFtjCIHxGVLIGLb/94C763zdQORh5xTs7MRP2FhQSb+fPzrATcpWhj7pepgPjdk9Q5tnnVXgX3RIuKyMBZhbaxutQz7k57NhaRm2d/6LECl9Ck5NSCwzPohnQwdXoPre4siogx5I7gxTNqwHEIvfLcwQLPsQb7rNNfEc/zIDMrEkZ+s50m2H4mg+qlOrBbOucUKydUSTA002Y2Xf286EUc77Ee5UvrG6Ky4h1Esb1Dtop7ZNDgbtQg1nmoBJTgWbkE1bgM/g6YAoSe+MbiZud4wzF2IgjlgyNEQpcQfy9u5O0rVG5RfqPNey+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(4326008)(55016002)(316002)(71200400001)(64756008)(9686003)(76116006)(45080400002)(478600001)(5660300002)(33656002)(110136005)(52536014)(54906003)(7696005)(83380400001)(8936002)(8676002)(66446008)(66556008)(26005)(66476007)(186003)(66946007)(6506007)(86362001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0mtmNIoPSxEA4KvSupmojNwn29XJaYW8lDr//JTvYIoretY9E2S5H1RtmRlE?=
 =?us-ascii?Q?8KptY1Tr4f9YdSqRnq8QKARvDY9B7wK8XR/IDg/XuD015kOUxNhOWus7YsK+?=
 =?us-ascii?Q?GM4p+5BoAzXTwAOPOLLN4KWc/rgNkXD+Cw3nHhBN1iJrHul3Xj2Pm0T5pQzp?=
 =?us-ascii?Q?oLvKcxklqI7zOMX3o5IozngPJ/oIMk+k2KGAa/I+gyM0VzCz4VaIrmDoHwy3?=
 =?us-ascii?Q?Y2QFQ0TmrTBQ/nKA4rbwGs6Pknr83bHyZA1z7reN2TmvFgT1x1XLwuOJGXdk?=
 =?us-ascii?Q?oX5TK8AkMT+NlcaKz1Lf1hyV3HETg0hleyhLxN5rPIOvUEpSwenIUyhxYN6g?=
 =?us-ascii?Q?TjPFX7KUMJbU8/I0DnVOslYUa3E0ryUyGjTSkfPZKdD6CfwVpsATNn2ta5MX?=
 =?us-ascii?Q?lUde3ZKAGYT1PPnNbcGoR1w7FJB9ZtnQMsO0Q1SEE/MSKFy8Sguem9HzNELZ?=
 =?us-ascii?Q?6WziVIBhVTrQgX5TKt/ZyaW13Eu3Xh/wtutlQ/uNTqfRWFtrN4gh64H8IgTX?=
 =?us-ascii?Q?FD0/yPT06Rw1OxHNKhcUPauaGZlxgGo9TVsvT88iqEVCA5G/XMrvKXjQpHgU?=
 =?us-ascii?Q?YkuMp61TWpXLvRZi9jeaPIkxKRZxXz9ptE8A4/3QaGaO2GF8HHTVvket0/w4?=
 =?us-ascii?Q?2P+9fv1GdzfRYoqbv2EJ8afxOYR/9cJ3W5DALJ4m4w/xLzm5WYE/8vve/a+y?=
 =?us-ascii?Q?gnrAQKRejKZM+QQS1Z8husG8jh4Dx6cHn+G8tdHdC7cjy+naI2m3yXhNGFVo?=
 =?us-ascii?Q?K2boY2wrAapeWD4ZnHR2xupMnqi/nB3hShQ9y6fA2jseOz5JcpOtiG2ESjMy?=
 =?us-ascii?Q?mw5WcGI2V67XRVMhknBNbs8oetIX4h9Kw8rQr0Vy9FJe0NOO4sq/GKzxBeFa?=
 =?us-ascii?Q?nB0KCWD4TYlMivCt/xdWzgVwRho5LK5aEs0Gon+/A4v7j4Bi4Eziw4PXNL/H?=
 =?us-ascii?Q?ze1vHarwQd6HylzkXKhoTpJUt2mfyKHk3FxCo4L+SlmOcJ35iq9+r2iYaaOL?=
 =?us-ascii?Q?Xr4EzgINZozOK1/ayj26pba6MJ/ld81sDQXdHk2WI3Gtma21Gr4WU62bBfMh?=
 =?us-ascii?Q?U5vKmn8/hXW8ysT0hb/6GraY5wiIs3y3tZcxuctsR9vuLxruF0UVL7DKXB+G?=
 =?us-ascii?Q?BVwfmX+IozS5weyLQ/oS6y+DahtRgTEJBhTWWEAPBBZ09FyFEyj6sX1XV1gB?=
 =?us-ascii?Q?WQja5kIGZBV5RxnIthuSDtc5v7Kg0su7xwOJ669exzRBdI7UZbd24w2sXI8H?=
 =?us-ascii?Q?ZmxSTR5Bft3DI88x/IxqXydx/eh72hEIaowghabgdsfWsk1SXf415LlCPUGM?=
 =?us-ascii?Q?eJptaeTwWgQYYXuhkKYmKFX5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccdc217c-e250-4367-e967-08d8d3847889
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 20:41:58.3743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rp//xp/y+RvoDXG/hmJ8iiAj92EhEFp0slDYw54O2nTYzOqTGaDYqgRjL72WgYsq/baIAUxnQx/1NT2vgkExRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4121
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613594633; bh=2bYTY+6odKpJu+U+yoItoHG/H9pBhSw7VNp1twJQ/lI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:msip_labels:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:x-header:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=aGDZCzBgq7g6TQrFWhcEgVIAnGaE8bbxXz7u19P2Uq6jwQeGvoOkwVofrMii0EwXC
         7py8tA+fmVWjVa2s0BzGjCnS0fanLuxQx4hFOGW0SMwiuUYSl8aPCatSuUIY2X2EoT
         MCsJdI6huZ/kqDxaLWV7rEZkzM9FiROV8TMT+4Zky2nepSgyxz0sVLroAVKY8NgmVo
         RRp9qBsAgV7/ibapoUaaoTHkCI0/yu2B9afNfI572amj4fUyd0+5sqgQiaqfPDi32j
         5LxfHTmFUydYIh2f4Nmv0Q9yveTSDtHwVeG5XAlfakAQrL35CoZVBJVQwVaLxd19ri
         BHOkIYFokZs0Q==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly and Paolo,

Sorry for the delay in response, finally got chance to access a machine wit=
h AVIC, and was able to test out the patch and reconfirm through some bench=
marks and tests again today:)=20
=20
In summary, this patch works well and resolves the issues on clocksource ca=
used high port I/O vmexits. With AVIC=3D1 && stimer/synic=3D1,=20
=20
1.	CPU intensive workload CPU-z shows SingleThread score 15% improvement 38=
2.1=3D> 441.7,   =20
=20
2.	disk I/O intensive workload Passmark Disk Test gives 4% improvement 1270=
6=3D> 13265,             =20
=20
3.	Vmexits pattern of 30s record while running cpu workload Geekbench in gu=
est showing dramatic 90.7% decrease on port IO vmexits, so as the HLT and N=
PF vmexits, when we get stimer benefit plus AVIC. Details as below:      =20
=20
AVIC=3D1 && stimer/synic=3D0 && vapic=3D0:
=20
             VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time=
         Avg time
=20
                  io     344654    68.29%     1.10%      0.67us   2132.72us=
      7.01us ( +-   0.19% )
                 hlt     114046    22.60%    98.85%      0.42us  16666.32us=
   1903.26us ( +-   0.66% )
avic_incomplete_ipi      19679     3.90%     0.03%      0.38us     22.67us =
     3.66us ( +-   0.71% )
                 npf       8186     1.62%     0.01%      0.37us    235.76us=
      1.46us ( +-   4.20% )
            ........                     =20

=20
AVIC=3D1 && stimer/synic=3D1 && vapic=3D0:
=20
             VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time=
         Avg time
=20
                  io      31995    38.61%     0.10%      2.79us     65.83us=
      6.70us ( +-   0.35% )
                 hlt      22915    27.65%    99.88%      0.42us  15959.14us=
   9535.38us ( +-   0.50% )
avic_incomplete_ipi       8271     9.98%     0.01%      0.39us     79.03us =
     3.58us ( +-   1.23% )
                 npf       1232     1.49%     0.00%      0.36us    100.25us=
      2.58us ( +-   6.98% )
	..........                                                                =
                                                                          =
=20

While testing, I also found out hv-vapic should be disabled as well to make=
 AVIC fully functional, otherwise it shows high vmexits due to MSR writes w=
hich seems to be due to  increased access to HV_X64_MSR_EOI and HV_X64_MSR_=
ICR. This makes sense to me, since AVIC conflicts with PV EOI/ICR accesses.=
 So far I think AVIC=3D1 && hv-vapic=3D0 && stimer/synic=3D1 combination gi=
ves us the best performance. However, AVIC=3D1 && hv-vapic=3D0 && stimer/sy=
nic=3D1 is really unstable, and sometimes would lead to boot. Wanted to und=
erstand if instabilities with APICv/AVIC is a known bug/issue in upstream? =
Attached the reproducible kernel warning in the bottom.
=20
In all, AVIC=3D1 && hv-vapic=3D1 && stimer/synic=3D1 could work stably now =
and still produce great benefits on vmexits optimization. Thanks all you fo=
lks help so much, hope the patch in kernel and bit expose patch in QEMU cou=
ld get into upstream soon along with fixing the instabilities.
=20
Best Regards,
Kechen

---------------------------------------------------------------------------=
------------
[ 7962.437584] ------------[ cut here ]------------
[ 7962.437586] Invalid IPI target: index=3D2, vcpu=3D0, icr=3D0x4000000:0x8=
2f
[ 7962.437603] WARNING: CPU: 4 PID: 7109 at arch/x86/kvm/svm/avic.c:349 avi=
c_incomplete_ipi_interception+0x1ff/0x240 [kvm_amd]
[ 7962.437604] Modules linked in: kvm_amd ccp kvm msr nf_tables nfnetlink b=
ridge stp llc amd64_edac_mod edac_mce_amd nls_iso8859_1 amd_energy crct10di=
f_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper snd=
_hda_codec_hdmi rapl snd_hda_intel snd_intel_dspcfg wmi_bmof snd_hda_codec =
snd_usb_audio snd_hda_core snd_usbmidi_lib snd_hwdep snd_seq_midi snd_seq_m=
idi_event snd_rawmidi efi_pstore joydev mc input_leds snd_seq snd_pcm snd_s=
eq_device snd_timer snd soundcore k10temp mac_hid sch_fq_codel lm92 parport=
_pc ppdev lp parport ip_tables x_tables autofs4 iavf hid_generic usbhid hid=
 nvme crc32_pclmul i40e ahci nvme_core xhci_pci libahci xhci_pci_renesas i2=
c_piix4 atlantic macsec wmi [last unloaded: ccp]
[ 7962.437630] CPU: 4 PID: 7109 Comm: CPU 0/KVM Tainted: P        W  OE    =
 5.8.0-41-generic #46
[ 7962.437633] RIP: 0010:avic_incomplete_ipi_interception+0x1ff/0x240 [kvm_=
amd]
[ 7962.437635] Code: 9a 00 00 00 0f 85 2b ff ff ff 41 8b 56 24 8b 4d c8 45 =
89 e0 44 89 ee 48 c7 c7 a8 34 50 c0 c6 05 b2 9a 00 00 01 e8 d6 cc 3a fb <0f=
> 0b e9 04 ff ff ff 48 8b 5d c0 8b 55 c8 be 10 03 00 00 48 89 df
[ 7962.437636] RSP: 0018:ffffa7894f9bfcc0 EFLAGS: 00010282
[ 7962.437637] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff99347f1=
18cd8
[ 7962.437637] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff99347f1=
18cd0
[ 7962.437638] RBP: ffffa7894f9bfd18 R08: 0000000000000004 R09: 00000000000=
00831
[ 7962.437638] R10: 0000000000000000 R11: 0000000000000001 R12: 04000000000=
0082f
[ 7962.437639] R13: 0000000000000002 R14: ffff993345653448 R15: 00000000000=
00002
[ 7962.437640] FS:  0000000000000000(0053) GS:ffff99347f100000(002b) knlGS:=
fffff80470728000
[ 7962.437640] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7962.437641] CR2: ffff8006ace2b000 CR3: 0000000febd88000 CR4: 00000000003=
40ee0
[ 7962.437641] Call Trace:
[ 7962.437646]  handle_exit+0x134/0x420 [kvm_amd]
[ 7962.437661]  ? kvm_set_cr8+0x22/0x40 [kvm]
[ 7962.437674]  vcpu_enter_guest+0x862/0xd90 [kvm]
[ 7962.437687]  vcpu_run+0x76/0x240 [kvm]
[ 7962.437699]  kvm_arch_vcpu_ioctl_run+0x9f/0x2b0 [kvm]
[ 7962.437711]  kvm_vcpu_ioctl+0x247/0x600 [kvm]
[ 7962.437714]  ksys_ioctl+0x8e/0xc0
[ 7962.437715]  __x64_sys_ioctl+0x1a/0x20
[ 7962.437717]  do_syscall_64+0x49/0xc0
[ 7962.437719]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 7962.437720] RIP: 0033:0x7f4c09b1131b
[ 7962.437721] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff =
ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1d 3b 0d 00 f7 d8 64 89 01 48
[ 7962.437721] RSP: 002b:00007f4bedffa4a8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[ 7962.437722] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f4c09b=
1131b
[ 7962.437723] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 00000000000=
00015
[ 7962.437723] RBP: 0000563c35a94990 R08: 0000563c33b95a30 R09: 00000000000=
00004
[ 7962.437724] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000=
00000
[ 7962.437724] R13: 0000563c34196d00 R14: 0000000000000000 R15: 00007f4bedf=
fb640
[ 7962.437726] ---[ end trace 7f0f339c3a001d7b ]---

