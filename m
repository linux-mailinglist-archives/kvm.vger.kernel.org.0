Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343C540BBC9
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 00:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhINWnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 18:43:23 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50304 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235873AbhINWnV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 18:43:21 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18EKxR1T007081;
        Tue, 14 Sep 2021 22:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=i+vxxFZ1XGTRpgUYwtEQ+qc0OKctgO5NCXMrPpCHFf0=;
 b=fI2AXDSNA1IqaE+c1HX3yAvPZsPpQGOy4oUXKv8RY4nkbjXaI96cLQKnVwRE9iPktRXY
 E6vbiwYiCK9SXJGrGzariyCYY2b1seCVQ3gKjzWnY5YoDK8sbcpNRm4tIR2FW3X/6DxO
 OHMJnOSx/LMJmRLYz0nPoIENkZ9etlNR+dCP8Y7S66Bfku4kMQZfT5tLog/aqPr7GZRl
 sk/zMn+89xxwc8xFFZP/6S47sevrR0GHvBjNuFWZHgXR0+V2TfBS32xYuFZVAU3Ap0Mc
 ibAgYpwrSv7ZeamnZhCGSj2TNAMCrPBALbRm45948PZNc4pwIjqNfwSrG3UTa24nVm// yQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=i+vxxFZ1XGTRpgUYwtEQ+qc0OKctgO5NCXMrPpCHFf0=;
 b=Fa1O8JOlX6aT3ABjHX/pT3GkPQnyIQhWUmvU/Tmqo9prz0RrN0teeq9N0PkuxyMw7rnL
 Oi14LhlszMZChAIUrogQk9C3H4RdZ6njKBbVchCKF3BRcr3y0oMPrHaEKIZFRqLHxVzI
 1GW0QMsH8mQ6ubB7Il8zb06CyrJcIEdj4wRfAjLyEHFTPrNVEh1TiWiOJ/TdA4M5PHFz
 HZXxwp/7iPImG0tUW0WzOcVgK7HFUaEcS8MOkovR7Ntt544feUwCsb9NRnHSoZhxpEXl
 uMTu81dFJ73RNA46NstrbvOl/td9FA/QZtkBIzvgAa98/7Qskn3jj21m0F6Gq93mThBl 0Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p4f33ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 22:41:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18EMeXKi097492;
        Tue, 14 Sep 2021 22:41:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3030.oracle.com with ESMTP id 3b0jgdrwvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 22:41:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtpFlhal+Vdt8nhCooFzcYfHLwpq2qHMPHFgk4vahz6L5pLRn1+fPfA2xG7qTL+ZbPwhdAXCpXktnpkCYD68geyJGtu43N3dNnPsc9qE5/cZhwEBMvyedbMh7gO/ap5dbOuqzhfUyrqF7gWI1kBZRB7SHmZNSKBI9CHmtxkzRWwcqeVAXo2SvQDedz7d0PGhgUgt8KoOqtCt/SuQWptE6utwkY4PNSvgV/OS1sko65wgOG4o9b5Ajoktj2ZowHMfDUX4dW99OVhAop1oy2WWx4uvug51GaFYSl+9N/BZBG1Gv8eHcfdFTS+5kQaOvKja77ZV1Br+F4DO5iUBDrn0+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=i+vxxFZ1XGTRpgUYwtEQ+qc0OKctgO5NCXMrPpCHFf0=;
 b=ZoytUjAZ237FosixdxZHx43xYW3M9B4oWq9F4PgeraJWNPvkcy9YfS6HqL/HbbUsGF2T+lGV2Ozf455rhGragvb1sfFQwyticScvl10IXXHfjgoFlMyWaIDmiCdAkP+mS9QPpf6wmVflV8JDkS8am9Y1B73Pc9Tijx5OdcvUJj2H4TkljXAuoZYSlglssT/8eHJPff+IZdE/DAoPPkmxr4vwAv+C0gPDLbJtlPkPa7ayR3HuIwgyEToERsOMQSHHD5Wn5joIPqxu4ocpLIO3kmURdRUdKStRvC8nLzBbWZ4hEYIf2Lhkvg3bgtLd0snARZh8hdzWFK7Gay1Cvsu4Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+vxxFZ1XGTRpgUYwtEQ+qc0OKctgO5NCXMrPpCHFf0=;
 b=H6YeqAwFAVaX5IAui0aEl9ZEN4G/1oSMLNZXi07HJwZllqBMB8/bNspsxNHXJKLPFBFuVqQLbbWX0LoQaXD4QMCvNz6dGKVCJiMTHN4r3QqUFrwz7VzWQ3fc8QJlxDDcNMwGyPBrtOS35ehK4PVV1i3xaCAW+t6QrG2P0pKXdug=
Received: from DM6PR10MB4380.namprd10.prod.outlook.com (2603:10b6:5:223::19)
 by DM6PR10MB3578.namprd10.prod.outlook.com (2603:10b6:5:179::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 22:41:54 +0000
Received: from DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3]) by DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3%5]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 22:41:54 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     David Hildenbrand <david@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: Re: [PATCH resend RFC 6/9] s390/pci_mmio: fully validate the VMA
 before calling follow_pte()
Thread-Topic: [PATCH resend RFC 6/9] s390/pci_mmio: fully validate the VMA
 before calling follow_pte()
Thread-Index: AQHXpZcbJLTjiRrwCkuHdXeigSfj7KukKDqA
Date:   Tue, 14 Sep 2021 22:41:54 +0000
Message-ID: <20210914224149.pet5qov4233sg5nw@revolver>
References: <20210909162248.14969-1-david@redhat.com>
 <20210909162248.14969-7-david@redhat.com>
In-Reply-To: <20210909162248.14969-7-david@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c099958c-a73d-4e06-0955-08d977d0da21
x-ms-traffictypediagnostic: DM6PR10MB3578:
x-microsoft-antispam-prvs: <DM6PR10MB35781BE03D768F873A00E1BCFDDA9@DM6PR10MB3578.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:568;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8V0VLeun39yHYmJs9AZ4kGEfVdX1w2sqRiDbaNEbW0CnAB+yeCW0M/YPgtN2X9sZND1Chg6YTBkbjTUR7JnthXcaKeGgDzUFZZyaqokI43+P0r3hpiDSd5Y4B6Sn/kG7glC01aDNMWYR8DQgRtWCO3ON6msxccwsty3jikEcooPQ2XcdMHeI1xKJzglpYfg6u1gjLsl3YBd9YcreBHUPq4Ymf1s0cmCCUZW5bb08HbauljCPjPMY7fzZfLz8SXhOSX8lPw5A4EYk2Fbjcd/+w3jZ5KzCdzU4OFR2eY+6bdOgdJk1nwG8uLG3JKxyLwegmu0TUs7B4F4wesUSIWFJqgiyumsdEGXwHUPAh6RNY+3zO52pQZtHKEJdfln/9Qo13uf6BQZ9iW4RB0UBTtFS9syIgTL2HTBSJzJ2Ws5uifnWNwGbZnH57rL2ZjEY2rdG/LBTfCmAADZPj99XfrF01O+2feJEvDSZ1ZUxjMV4IDh6lc9LbZaaAoIL0xO7hB/e5N7Mc6CBMD6tGdc7/xcGG9N2aURP6BuhUlr0QMxgsqApAJOBH2NBlYcImAz39HIVf4Dl9MLOGN8EcychrQToKqBfYu8MtkfnMECzYFalUcJ5HNzfOxxvT0i5VAStENiGeCT8e/TlkSp46QdUiviYg5/tJCYYQgCiwdi8y8f79sfsMLx2gYEhp4Ecf4ppt4s/SRie0D3MR4LdznBtEWGlgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4380.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(39860400002)(346002)(366004)(396003)(136003)(376002)(83380400001)(33716001)(1076003)(86362001)(6486002)(44832011)(6506007)(54906003)(6512007)(26005)(38070700005)(316002)(6916009)(122000001)(76116006)(186003)(66476007)(5660300002)(8936002)(66946007)(91956017)(478600001)(64756008)(66446008)(66556008)(4326008)(8676002)(2906002)(7416002)(9686003)(71200400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aP3P4eOfUfJVjFCC5W/aKzwqHXT9ZxvqQg2kKquZ84eyFLB/qPw2oMMsgC2q?=
 =?us-ascii?Q?72Ua+ttkGf7KtrM++vcDAGzT88qYQb5fKZndvY8mGWdv2GmsIZ7O7v7SB0/9?=
 =?us-ascii?Q?MEw1wX7zfl/AwH/MrU4tLTVCUPUJwd2T4fqFWTx1NodrkKC55Q91tezCAsEX?=
 =?us-ascii?Q?BAh+1yzlnz5t/lpNBY88fnxYJcBcLXFSIAqw2yJYtxKPYlDrNO+2YhbZ5PoG?=
 =?us-ascii?Q?/mhLzpIH5kCH2jqYfvqw5bRY6Z6hI+4tj87QLzGE6N6uJPIOAVFg/wW6TcGn?=
 =?us-ascii?Q?Ji/OZo5yz5++Q7pK3zcNGOsyGJcuXtF+SC6ezHfl8ca/CZypCoKz/ywLj+rM?=
 =?us-ascii?Q?aXEhYVfd5v1BNISXZC5VzF34IsRuUTKRIRuBBUJr5ZV7zIhZr05XQP3rsASG?=
 =?us-ascii?Q?B8BHJEwczMg75kvJLdSCbrEtZdoBbCel4mBciamFVQ0odl4FIebUOG0aqmkR?=
 =?us-ascii?Q?rtpENJBNHn+HQhBbcsl6tPAGyQSIPDJ4XVDqx8q6gdVykMiWXukyWJPJ49zI?=
 =?us-ascii?Q?2aidcb10ZgwgBwx+0SWrdIVG5w+HD952FxH00dSSj0YxcZR5E2oCJbb+3tZZ?=
 =?us-ascii?Q?vwEcgBz5IbveLlNwhNmf2S47y/5dtdLbIW5nGjyC1LXsByZryKFxabDpqTK5?=
 =?us-ascii?Q?dmAxe9jG50dXRfypRnFYBMNcdNnlrVbPL44BnxPgPL0v9w5Ze+Og6J+jWK7j?=
 =?us-ascii?Q?ZI+SoJsJu9Zs6xgtZ7nJLJNU5i0nd90FeO+IxAhXwB02+dH5AXcZQiIvYQY1?=
 =?us-ascii?Q?ex6WWm7s3bt5NzO3ddqy1uSMZVQysAQJoCtKi4bWHFB9aoaz0PsCEufEzdss?=
 =?us-ascii?Q?eNiWrj7PDGiQa592EgxcJAv85VVyC9UZUrYNt9MNrj/cFxQteFAQ/zRkaAbd?=
 =?us-ascii?Q?f46X36ZgpaPqEKgAtpQ1+zvhTZZ3WjkDNCPRHEZERK4qp4DHineq2SVZ8SiN?=
 =?us-ascii?Q?7WlyQe4bzzLI5CC08u9lQYcoXnNg03cbEg5hiIDGD0QyfiT/nDsN/pxTuFor?=
 =?us-ascii?Q?A5Rv8uWl+nNLBYK6RPtjbIFxzuRUipaC6bwBbz3Eg4+YJSL+IjjBK6Kr3Uqs?=
 =?us-ascii?Q?JLsDVAnduRcWwj4hWgpYOMOoA74LIbF+1S8wNIaUVkL5dL8vQezsO7muWDgp?=
 =?us-ascii?Q?jaYLVDdOmbk2WU61Pxzqo7IsPgEokpiB1XcYWXzPagoR3KJP+2zwB7OKdgNt?=
 =?us-ascii?Q?tOTpItWg+kdcYqMJ6e1NGeioQuVV3KrSapg7bgrJoCb+uwIL1FuzHDzqdMra?=
 =?us-ascii?Q?4Y8Xt8KcaFd/OktC+Mgb7PH1NmO1x2lwfTPjfZbGYbSUg0xXQNpnd/PSRtvW?=
 =?us-ascii?Q?Z350EJI9onTkBQDYQAwzm1Ev?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3EDD7F082EE8A142A8807D7957D5BA46@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4380.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c099958c-a73d-4e06-0955-08d977d0da21
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 22:41:54.4533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MHpxpY3ruPfCtE3pZPE+C1Hr2yvIiEF9CLcSLZYU7qXRERIFu1kCXk2oxBJquCn6pl+5p2kAkD7UjlBKwNvrFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3578
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140130
X-Proofpoint-GUID: HZl9165iNI28PvaLu8ody6Q8aToywI73
X-Proofpoint-ORIG-GUID: HZl9165iNI28PvaLu8ody6Q8aToywI73
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

* David Hildenbrand <david@redhat.com> [210909 12:24]:
> We should not walk/touch page tables outside of VMA boundaries when
> holding only the mmap sem in read mode. Evil user space can modify the
> VMA layout just before this function runs and e.g., trigger races with
> page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> with read mmap_sem in munmap").
>=20
> find_vma() does not check if the address is >=3D the VMA start address;
> use vma_lookup() instead.
>=20
> Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/pci/pci_mmio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> index ae683aa623ac..c5b35ea129cf 100644
> --- a/arch/s390/pci/pci_mmio.c
> +++ b/arch/s390/pci/pci_mmio.c
> @@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, m=
mio_addr,
> =20
>  	mmap_read_lock(current->mm);
>  	ret =3D -EINVAL;
> -	vma =3D find_vma(current->mm, mmio_addr);
> +	vma =3D vma_lookup(current->mm, mmio_addr);
>  	if (!vma)
>  		goto out_unlock_mmap;
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> @@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mm=
io_addr,
> =20
>  	mmap_read_lock(current->mm);
>  	ret =3D -EINVAL;
> -	vma =3D find_vma(current->mm, mmio_addr);
> +	vma =3D vma_lookup(current->mm, mmio_addr);
>  	if (!vma)
>  		goto out_unlock_mmap;
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> --=20
> 2.31.1
>=20
> =
