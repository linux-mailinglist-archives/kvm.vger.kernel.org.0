Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1AC5D651A
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 16:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732518AbfJNO1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 10:27:07 -0400
Received: from mail-eopbgr1310135.outbound.protection.outlook.com ([40.107.131.135]:35280
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732362AbfJNO1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 10:27:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q23XmHqFqZpK4ubFNFwTZKAj2T8FKZxNlesPT1HMW/VAu2Zz0+dscNlXQLkMkKovJQClnk+cIzpYPxkqEaO80utm5KPvPA/aEPa03FNVfG8mpCBLHlYwKcnJ51pYtnkF68pnie1PZ6dgWBlDiAcJ/awIW46dw2fkLBISnb4zmQZhRawGEIrnCa7mgGtp4zpI6xtlr8vRXe+cIcB8oHD9KnmPHnS9bfoxzjdNbc3yBvG7m1l1/XTB1YYWuMDdZfoaGJqK1sQBph9egpHdwqzBi7NbOCY5TXcYsrl9IYz0VWS4Fui4VYCmaDZC+iHpgh6RC22Bue4SxnBtb5897qc4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnuyZLq6XAOnG7RthxXE5XnKoDZRSZkCMIVMRPRxzLM=;
 b=MUQUsGm/2y69YgUUPomvnve8IkvUFumlcnEqK/7o1S8yVWoOnV1NKuNUuIte5P2ZLbx9Xxzm4htuJvi/7QMpVcN09FS1GKp/irvmoy41XfyFmIgIGHpOPXk9DNTgUs0nYAphStMLem7J+U0C07oMV8wE3Ys1wiWaRQth3HWDHrhrH5Eoa/YY2kdiUOcWAcfF986iFjqDeP87UqZIMyLzFy2/2kjb0KBLGbPmjD938o06a7WBcmNO99a652shE+5OIhDaTDblck8dmE0hOcfpcwgxRm6AUm1ofbWgnYfJ162ERVwamBOyq9wlA9javYuWTwDOoBfTtS+FBHQZs8CqBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnuyZLq6XAOnG7RthxXE5XnKoDZRSZkCMIVMRPRxzLM=;
 b=JdudXCvDDxgfaeeNuYCh2Ty3WbySV6wHfs6cHf5KOGCrrmNJ3r9LHVBVVHM0EzvBCmuysPkb50LoIs4OABO+Dz72MxSC0pmiIeDp96LhrQ8TMyQl8HBr2CHw3KmrQzEYqtWthK8c2HtZz22sDj/WxvY9ek9Ygh/o/BhJcIdNcIo=
Received: from KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM (52.132.240.14) by
 KL1P15301MB0278.APCP153.PROD.OUTLOOK.COM (52.132.240.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.3; Mon, 14 Oct 2019 14:26:02 +0000
Received: from KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM
 ([fe80::d4ef:dc1e:e10:7318]) by KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM
 ([fe80::d4ef:dc1e:e10:7318%6]) with mapi id 15.20.2367.014; Mon, 14 Oct 2019
 14:26:02 +0000
From:   Tianyu Lan <Tianyu.Lan@microsoft.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     vkuznets <vkuznets@redhat.com>,
        "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: RE: [PATCH] target/i386/kvm: Add Hyper-V direct tlb flush support
Thread-Topic: [PATCH] target/i386/kvm: Add Hyper-V direct tlb flush support
Thread-Index: AQHVgK8HkSJ/Ajtt/E6pHX3BH3x3w6dYROIAgAHM/1KAABjagIAABs9Q
Date:   Mon, 14 Oct 2019 14:26:01 +0000
Message-ID: <KL1P15301MB02619B5B1EB5BB1E83881F8292900@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
References: <20191012034153.31817-1-Tianyu.Lan@microsoft.com>
        <87r23h58th.fsf@vitty.brq.redhat.com>
        <KL1P15301MB02611D1F7C54C4A599766B8D92900@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
 <20191014154825.7eb5017d.cohuck@redhat.com>
In-Reply-To: <20191014154825.7eb5017d.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=tiala@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-14T14:25:58.9876832Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8e1190ff-2cb9-4d6c-92c2-9bf4003561ae;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tianyu.Lan@microsoft.com; 
x-originating-ip: [167.220.255.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e25e57b-93b2-4b63-65e8-08d750b270de
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: KL1P15301MB0278:|KL1P15301MB0278:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <KL1P15301MB027820A8949E6C07534B751C92900@KL1P15301MB0278.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01901B3451
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(189003)(199004)(11346002)(229853002)(9686003)(446003)(476003)(305945005)(74316002)(7416002)(55016002)(6436002)(66066001)(54906003)(2906002)(26005)(33656002)(3846002)(10090500001)(53546011)(6506007)(486006)(186003)(6116002)(102836004)(76176011)(7696005)(8936002)(5660300002)(14444005)(52536014)(316002)(86362001)(6916009)(256004)(81166006)(81156014)(8676002)(8990500004)(66946007)(66476007)(71200400001)(14454004)(6246003)(66556008)(64756008)(478600001)(71190400001)(76116006)(66446008)(7736002)(99286004)(4326008)(22452003)(25786009)(10290500003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:KL1P15301MB0278;H:KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 06djXRVZ09XoOk6H9bDUw3VlEsgygzckXN+sueKn3rUVFemy3VKI1seGw2HYQu5Uzud6gpfop77Vl8Cm7Qa/R9e0fAq+zPLBB2Vn2K5vLhTwLm/l02NXiUgqn/DdTn4ueP3I6dVZK3a1cJOHrJcFJ+z6CvSgizGCpzqq2YXaVFU6rTtr47UFgjw720c4tS6abou70Qe1pAB681jJk6DqRdWx2FYoLYeihNy8NurKebR51dJrOaN9IW/eYXzM+poIis+DbmId5GvcXacRd6SyCPJSTNJyzjpslcb+qnfEFvtq5gOC31zljZO91HRFlZsYVi4I9cbaw3eIlG+u4GaBk9esGpNf0PTAVrM+7TbDfMs8y9oDyTYfBhjbwyVlsO08WmkIx2u7mt11nnUvix2hGm5xe5PAogIpUm8r3FMrGF4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e25e57b-93b2-4b63-65e8-08d750b270de
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2019 14:26:02.0011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dav6m7GaCXXusB7lyIyn8PTSl8Cc7ffjdSX0XulY8mQt2vIbA3s39fkJs/PRKzxLQHmpbNetiWAxRlaqeo8EDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1P15301MB0278
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 9:48 PM Cornelia Huck <cohuck@redhat.com> wrote:
>
> On Mon, 14 Oct 2019 13:29:12 +0000
> Tianyu Lan <Tianyu.Lan@microsoft.com> wrote:
>
> > > > diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> > > > index 18892d6541..923fb33a01 100644
> > > > --- a/linux-headers/linux/kvm.h
> > > > +++ b/linux-headers/linux/kvm.h
> > > > @@ -995,6 +995,7 @@ struct kvm_ppc_resize_hpt {
> > > > =A0#define KVM_CAP_ARM_SVE 170
> > > > =A0#define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
> > > > =A0#define KVM_CAP_ARM_PTRAUTH_GENERIC 172
> > > > +#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 174=20
> > >
> > > I was once told that scripts/update-linux-headers.sh script is suppos=
ed
> > > to be used instead of cherry-picking stuff you need (adn this would b=
e a
> > > separate patch - update linux headers to smth).
> > >=20
> >
> > Thanks for suggestion. I just try the update-linux-headers.sh and there=
 are a lot
> > of changes which are not related with my patch. I also include these
> > changes in my patch, right?
>
> The important part is that you split out the headers update as a
> separate patch.
>
> If this change is already included in the upstream kernel, just do a
> complete update via the script (mentioning the base you did the update
> against.) If not, include a placeholder patch that can be replaced by a
> real update when applying.

OK. This change has been upstreamed and I will send complete update patch. =
Thanks.

--=20
Best regards
Tianyu Lan
