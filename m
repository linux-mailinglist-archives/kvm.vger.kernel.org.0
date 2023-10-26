Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1727D7C7B
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 07:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343862AbjJZFtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 01:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjJZFtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 01:49:50 -0400
X-Greylist: delayed 355 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 Oct 2023 22:49:48 PDT
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF628F
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 22:49:48 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.22/8.17.1.22) with ESMTP id 39Q4WK2C002473;
        Wed, 25 Oct 2023 22:49:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
        from:to:subject:date:message-id:references:in-reply-to
        :content-type:content-id:content-transfer-encoding:mime-version;
         s=proofpoint20171006; bh=ebNK1Uf8WV6uQa+KQk7LmqkHETEbj8QdyR1waX
        UM2yM=; b=uH8x077w4u1pfJHu5CCgPB2ttKcAYMUMcItEm/3zOlv5txevTzM+8R
        tTiGc13OyYFxZodDsl6UnZbX0EBEq2P/Dsne5bbRvSxDH3jssWM3cNBIbLm0EBNR
        9bwyoDwGWEHaksMW4qrRVX0k6wqMm0o/AWzXlY+SQInkDj+AoRp53i8dU/h4ZHTB
        eEiqZgeLOE/XrlYPlXyw8R/AkmXQDI7pHeNKiKphDbPhQTZSis15TKXxeN5XojEJ
        JhMj2Wbq30xM8X49zSAr+jWNMPUbeS3sdEd8DF7ie9AmC4FYWW3gRMDncU2hsZYa
        +BdfD4I2+eBnYhe8yatftXd7xe+pUr7A==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3tvayqyk0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 22:49:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJmBSu8eI09UjaqIfzmMIED+r/MJrcdiANhVkD91UNQ4SsZRFtYuAyABAnAhSc45/51NjaaUk8XaEOdU0bAkY/jDMny/8HTnrc3ldsdTHEkmWPj33Wmq/ftMRnfIpGNegPqewQAOu5OenkpY7DKQN+h0UXeyz0IzhtRwNOB95yvL5CrhX+Gad9pwLA6YwPquOtb1nQpcilO87aH5QRAJSRfSWts77izcFLHn3UhiSHpOb1tQVpZouwjnOzFcjYsTequmHCJnogYrIJCndbWNuHny6a6T+H4NY2WjBvihT61/D3jKZLIWGIr8Xym1CEoHUD2OxUFHxNb+0JXmE3qxEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebNK1Uf8WV6uQa+KQk7LmqkHETEbj8QdyR1waXUM2yM=;
 b=UjxGvD7XGLsMNRuf3vwwbMLsY32LcZH9ZfIkV7YHkjieiddo+PMC1h8qgoD4Rfh1TmSkKv8qYzo0iYpSnvIUmM2cjVopHSP7WUGQNItOqvzOzdV1Hcyi4oChpjcxuWmFFjrAfto0DF4AtEOC+bYYyEgOtNu4fmH7mq1vZx9cCsGmkyzgyy/kHJtQlQf55jJqtJiiQ+abeBolzkbbeLfxYv8faOaj5LQiohD1vmi7LDsIWfXDGVjh4VhXMz1QnGD01mYGwzw9uB+2T+bdYy1ZeP2d6N23yl3yu504SZiD/L04ZMFiknaNdA88a/Ir4LsLpHTpWrTENBrf++rtIrLDHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebNK1Uf8WV6uQa+KQk7LmqkHETEbj8QdyR1waXUM2yM=;
 b=EwbXhZ95I/MYFl+S9tZ0cjK8BfNJmv+eV1P6y90MjNhI0OB/bOiDpql/+EqrUNMk5JzN795kCYyQFRke+CCf7ZnS4HGdutL2L06c5OkbEUdcTG/y+l0obC6d+Ny6fO11BrJviJSHvHNvXvAe7Avcd+CpHBvu9x0vtGONclXRN1RiqOHIaxQBSPDRSOO/90DAlQcXPnpGEnSNY3PbqXKoXuPWvZyMxj5DkLQWA3jwDT9ntdlU/7mAWD/Rcle8o2G885zXGIO0eGGjSmB7Lb+ll3EKOyQnjsb064B9YKsEej2lD3xP9QClVr9JI/ZPBobC+bz+8R6uMa5WNRKBqqdJwg==
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by DS0PR02MB10250.namprd02.prod.outlook.com (2603:10b6:8:192::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31; Thu, 26 Oct
 2023 05:49:37 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::22f:727b:8c9a:e456]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::22f:727b:8c9a:e456%6]) with mapi id 15.20.6933.019; Thu, 26 Oct 2023
 05:49:37 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before
 kvm_put_nested_state()
Thread-Topic: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before
 kvm_put_nested_state()
Thread-Index: AQHaB89aXI5Xqc3T6k+NVdRuk3VgqLBbkLwA
Date:   Thu, 26 Oct 2023 05:49:37 +0000
Message-ID: <D761458A-9296-492B-85B9-F196C7D11CDA@nutanix.com>
References: <20231026054201.87845-1-eiichi.tsukata@nutanix.com>
In-Reply-To: <20231026054201.87845-1-eiichi.tsukata@nutanix.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR02MB8041:EE_|DS0PR02MB10250:EE_
x-ms-office365-filtering-correlation-id: 223832c7-334b-4bcc-12f9-08dbd5e75707
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x+VFSyGgQo/h1gLfSPqq3t9d8K0jP/qKUgD7aOFBOcfFLjTNOuXIZp9dmv+e5jzHemplC6xAZDNawg3Vfi7mwLl62bmGyq6KVZtB20evB50vDvczSAoPE2Z71S/OpajgbeSZTQa0nQTsZ+ty2XWwBa88OfZa9uGMUhnQekV6oKBKDqwISHdTeaF3n2IaIfsSpIS/x40OMSdZui48UyFIP4H7D4xX+X+a9L4NO83jy+kJrfSRauYdxDM4u1WKKYwREXjPOeKaV4k/Z888yE/WziWzYiHFao9t677Iy+pex938hfWydXUpxRc6gR1PaUnY91fglpnlb0HWRb8GsDna0m8tAQTLQgNsnjvLRV9mSysZo8CS919LWmhCkTBto7TQ3X2BP1Fwsfopre0rHFAZ2nWYCq8+6cR0Z/DG6RaDPSl73UJuZry74MQ1VaVHwtIqkDwDErBX1W+CabjKeCF5VFKdKvuDzXdwv1srjqyBp0Do8+Ch96nBDqds0h0DbLflEQwsnxnmLXrx4cBeImu8w4sSBEjk+CuEHQUCndm5iyAcwkW7o1FaNtmyogOBDrNAvPtkR0MLHIBGY7+tuWBpeYzFVfmKFFHDbsh5pwWpF5oHXYcFpq7J+VezBA1UC4U38fX+KuLoodOCWGuoUHqTTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(346002)(376002)(39860400002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(83380400001)(5660300002)(86362001)(66446008)(76116006)(64756008)(66556008)(41300700001)(110136005)(66476007)(6486002)(478600001)(966005)(91956017)(6506007)(6512007)(316002)(66946007)(44832011)(36756003)(122000001)(8936002)(2906002)(2616005)(53546011)(38100700002)(33656002)(8676002)(71200400001)(26005)(38070700009)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/t2++KFl/V2urAJxvwX+ZyyseiuurG7u/bkNeU0qnwoxN2ZBCiENSMAR/1H2?=
 =?us-ascii?Q?FCJYb3i8Tmt88E07l56hcvpJn36PqiA+7uwXPrGmjXWOEYW1+05puX0cd2rN?=
 =?us-ascii?Q?V147LEUwBHUqSm4JNMhjN+3gK/9l0sSvMbvTDheskfx9GK7Lo6OVGm/ncEKy?=
 =?us-ascii?Q?hhhQRpYEZTW+D+Tm2734g91TBSRG31uATU0dV/ZTm2VMSAeRoAHQcZ4bijQu?=
 =?us-ascii?Q?cfTFygGrZoQRC5Xw/hTVJeg/jxuUi/Qnp3sjJ2Cvlym/BjP+uikcu+A7+9yo?=
 =?us-ascii?Q?wCAgWDu0dR8c31gh2m8VgZnXkIuTV0ydFJKPYuQVK0IgxBRHtc8RH2MEA4//?=
 =?us-ascii?Q?uKdnm2w30p/4gM3kxZYr9S+1XmFCQRGbAS60GX7yceQjuExr1dptOZZIr8SL?=
 =?us-ascii?Q?1CAANqS2OUPEbwpBC5zi0rBKKL9zUlwbMy74Jku+czwqZhhp/KKDGm8Hfq3D?=
 =?us-ascii?Q?tSW2b6kbbzxYVFdBDAg+0v87YcDy2LLrV47L12Drof8X4fFLtEDfQrXSlieQ?=
 =?us-ascii?Q?myPzY/JEavyh43gHd3tas3M0P4+apgmuuRHknnbGb/OXrE/njsWZaIWq+nXw?=
 =?us-ascii?Q?WjOEOS3w6l0Ot09mofPUr4hplMHof/eLEmdPE+fq69jrkfIgXQR4soBtayK/?=
 =?us-ascii?Q?NOmznjrAi5Sok0wojiYhPinMwEsl66wN47E7TiIFMDBg3kvttKvvZFccjBrD?=
 =?us-ascii?Q?awijWX2q3Xc3fEBTl+MnQPNpOmmvDf6bepAz0opwbmlt6le7Nfax3S8B0Cbw?=
 =?us-ascii?Q?3TNi6ILpB/7VN+9DmpW9e5hMkErTfzYKX9Il1yfMBom1VFz4RrCa5VuPnEqf?=
 =?us-ascii?Q?G69edFuip8O+6cT1aXuU7M19WomPOgM6AQohjGQn+S+/qe0GypDIRv9lQB/4?=
 =?us-ascii?Q?wZoTykqrBgHxYPLk9SPrt9H7j3PglKPLvYc0N/oSwTZc27StcW+AfexFxcr0?=
 =?us-ascii?Q?7CJFlo8+EJ1YLNfnE/DWuBTexJazjtEgc/K2cYkc4/KXWh+0rvOedknR0c8c?=
 =?us-ascii?Q?fhCMuHaQvgKB3V2RBLUdVsABpmg3szwlbCDywonSOtKwGFC+h+WmzhOcRxqP?=
 =?us-ascii?Q?/piyCd53IIQ1UypxTg08wmOZKDLMjFX3/qDLW9OLp7Am6XjbXYqTP0A+iEQ6?=
 =?us-ascii?Q?xUGqaNnEAC7zDfoIeH7lpqE7eq/UE1VAjLOpUv74VWqHru1rJZsiKOLVsVn0?=
 =?us-ascii?Q?J/XM6JNT089U83sHtZ9B18fDfFnoiZdQ0U7N/fqIbfACbDUw24H/f15XsYCl?=
 =?us-ascii?Q?6WV9T5/GxwHBkMRtie/PLPsHKBsisWKhS04GCY0C96XSUktLqdbiNbMr7NkR?=
 =?us-ascii?Q?Rn+kDmBzeDlv0n8+nONY0uWFny71m5Sl4KFWEiz74jAfeokzc03Ry0nX6muY?=
 =?us-ascii?Q?6yHcTzUdUwUZOrwLvVsN5imbt62EtSYUWF0HnIkLor/c628aI6sXkpD3Zcrh?=
 =?us-ascii?Q?u+rOLP2q/AOlzxQMbxRxSD835sIWsKXDvwepyRBWGrCRuns6oDmWka28F6sg?=
 =?us-ascii?Q?CzHG+aynweNdpPIsrhzGoz8AJat37RMbUXlYSx1pkSFdG94pSo5ModCy8wh4?=
 =?us-ascii?Q?yY8gDXA+idrbZH55v7iQ+EoSiGGH+6TexCJpxkwm1B5AdC70fPhbSAB5/i2m?=
 =?us-ascii?Q?Ig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA9B1CD3F4559348B8CD054C91EFEE1E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 223832c7-334b-4bcc-12f9-08dbd5e75707
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2023 05:49:37.6728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kNRNXTZD896+3NpP1Jzbvg6PM5ByaGj6982YCOlNBnHqDdFl1MWHq7TTSSzkFOzm0H5XCiQS+++uR4EIsOeuoPO1GdwrIG9tTaXY/ilrkfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB10250
X-Proofpoint-GUID: GQftvswc8YTUQL0o5pw-csL76z0b3EV0
X-Proofpoint-ORIG-GUID: GQftvswc8YTUQL0o5pw-csL76z0b3EV0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_03,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Here is additional details on the issue.

We've found this issue when testing Windows Virtual Secure Mode (VSM) VMs.
We sometimes saw live migration failures of VSM-enabled VMs. It turned
out that the issue happens during live migration when VMs change boot relat=
ed
EFI variables (ex: BootOrder, Boot0001).
After some debugging, I've found the race I mentioned in the commit message=
.

Symptom
=3D=3D=3D=3D=3D=3D=3D

When it happnes with the latest Qemu which has commit https://github.com/qe=
mu/qemu/commit/7191f24c7fcfbc1216d09
Qemu shows the following error message on destination.

  qemu-system-x86_64: Failed to put registers after init: Invalid argument

If it happens with older Qemu which doesn't have the commit, then we see  C=
PU dump something like this:

  KVM internal error. Suberror: 3
  extra data[0]: 0x0000000080000b0e
  extra data[1]: 0x0000000000000031
  extra data[2]: 0x0000000000000683
  extra data[3]: 0x000000007f809000
  extra data[4]: 0x0000000000000026
  RAX=3D0000000000000000 RBX=3D0000000000000000 RCX=3D0000000000000000 RDX=
=3D0000000000000f61
  RSI=3D0000000000000000 RDI=3D0000000000000000 RBP=3D0000000000000000 RSP=
=3D0000000000000000
  R8 =3D0000000000000000 R9 =3D0000000000000000 R10=3D0000000000000000 R11=
=3D0000000000000000
  R12=3D0000000000000000 R13=3D0000000000000000 R14=3D0000000000000000 R15=
=3D0000000000000000
  RIP=3D000000000000fff0 RFL=3D00010002 [-------] CPL=3D0 II=3D0 A20=3D1 SM=
M=3D0 HLT=3D0
  ES =3D0020 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
  CS =3D0038 0000000000000000 ffffffff 00a09b00 DPL=3D0 CS64 [-RA]
  SS =3D0020 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
  DS =3D0020 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
  FS =3D0020 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
  GS =3D0020 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
  LDT=3D0000 0000000000000000 ffffffff 00c00000
  TR =3D0040 000000007f7df050 00068fff 00808b00 DPL=3D0 TSS64-busy
  GDT=3D     000000007f7df000 0000004f
  IDT=3D     000000007f836000 000001ff
  CR0=3D80010033 CR2=3D000000000000fff0 CR3=3D000000007f809000 CR4=3D000006=
68
  DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000 DR3=
=3D0000000000000000    DR6=3D00000000ffff0ff0 DR7=3D0000000000000400
  EFER=3D0000000000000d00
  Code=3D?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? <??> ?=
? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?=
? ?? ?? ??

In the above dump, CR3 is pointing to SMRAM region though SMM=3D0.

Repro
=3D=3D=3D=3D=3D

Repro step is pretty simple.

* Run SMM enabled Linux guest with secure boot enabled OVMF.
* Run the following script in the guest.

  /usr/libexec/qemu-kvm &
  while true
  do
    efibootmgr -n 1
  done

* Do live migration

On my environment, live migration fails in 20%.

VMX specific
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This issue is VMX sepcific and SVM is not affected as the validation
in svm_set_nested_state() is a bit different from VMX one.

VMX:

  static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
                                  struct kvm_nested_state __user *user_kvm_=
nested_state,
                                  struct kvm_nested_state *kvm_state)
  {
  ..           /*             * SMM temporarily disables VMX, so we cannot =
be in guest mode,
         * nor can VMLAUNCH/VMRESUME be pending.  Outside SMM, SMM flags
         * must be zero.
         */           if (is_smm(vcpu) ?
                (kvm_state->flags &
                 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDIN=
G))
                : kvm_state->hdr.vmx.smm.flags)
                return -EINVAL;
  ..  =20

SVM:

  static int svm_set_nested_state(struct kvm_vcpu *vcpu,
                                  struct kvm_nested_state __user *user_kvm_=
nested_state,
                                  struct kvm_nested_state *kvm_state)
  {
  ..           /* SMM temporarily disables SVM, so we cannot be in guest mo=
de.  */           if (is_smm(vcpu) && (kvm_state->flags & KVM_STATE_NESTED_=
GUEST_MODE))
                return -EINVAL;
  ..  =20

Thanks,

Eiichi

> On Oct 26, 2023, at 14:42, Eiichi Tsukata <eiichi.tsukata@nutanix.com> wr=
ote:
>=20
> kvm_put_vcpu_events() needs to be called before kvm_put_nested_state()
> because vCPU's hflag is referred in KVM vmx_get_nested_state()
> validation. Otherwise kvm_put_nested_state() can fail with -EINVAL when
> a vCPU is in VMX operation and enters SMM mode. This leads to live
> migration failure.
>=20
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> ---
> target/i386/kvm/kvm.c | 13 +++++++++----
> 1 file changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index e7c054cc16..cd635c9142 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4741,6 +4741,15 @@ int kvm_arch_put_registers(CPUState *cpu, int leve=
l)
>         return ret;
>     }
>=20
> +    /*
> +     * must be before kvm_put_nested_state so that HF_SMM_MASK is set du=
ring
> +     * SMM.
> +     */
> +    ret =3D kvm_put_vcpu_events(x86_cpu, level);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
>     if (level >=3D KVM_PUT_RESET_STATE) {
>         ret =3D kvm_put_nested_state(x86_cpu);
>         if (ret < 0) {
> @@ -4787,10 +4796,6 @@ int kvm_arch_put_registers(CPUState *cpu, int leve=
l)
>     if (ret < 0) {
>         return ret;
>     }
> -    ret =3D kvm_put_vcpu_events(x86_cpu, level);
> -    if (ret < 0) {
> -        return ret;
> -    }
>     if (level >=3D KVM_PUT_RESET_STATE) {
>         ret =3D kvm_put_mp_state(x86_cpu);
>         if (ret < 0) {
> --=20
> 2.41.0
>=20

