Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618E44DBB58
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 00:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344115AbiCPXup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 19:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiCPXuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 19:50:44 -0400
X-Greylist: delayed 1166 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Mar 2022 16:49:29 PDT
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA821ADBB
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 16:49:29 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22GFhsjP003660;
        Wed, 16 Mar 2022 16:29:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=proofpoint20171006;
 bh=PtAMGvY20bmgMGGftxjxoJjsOJf8sgk/YYzKvoTyKxw=;
 b=zbcSyAhgSCc8IpHVw6PfI7U1pg4jrGxHpbky6EKqGkr8irkxvV1XNjmslVjp/YFaHsjI
 SQJ25EnEClryLQ2rVWPTNgQr0r4SBKgrVvXoP6CUogtg+M1U0gMRixC/mNZRI9l9+BjI
 UaxpE9PhRnLmYtX8SIG6FZwUE3/MECLx6dAFszJCHyimn8beKKPR40ajI7B7dAikAfOo
 lEoEdxRRAqq5N+p51w55A61caVcOF0sKGwHozmbaCKiXwAQKQgNZwA598YXbHgRc7irZ
 oYwLevrXjzTXhJrKsfssO7IVwCHXRkLgGgkfc4Ccrj+l8rPU3w7pW3Ry2pbH9zqH4ff6 /A== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3et63h6cds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Mar 2022 16:29:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PieBE7Eu43ra4LN3fjN+A7ZhxiJKoKSuFPjsBOUso7IJxQlGOuTNYc5cfywolRr4JJcpZQtM8SCwoxojZ+yBKKKIRJ5Dn7rzqa9du4MXIBptgDUa2pxgbUdb8bf3FF73HOg7jReCjCi3Sbl/NTxRLrVDjPLx6fE2FmUoybRVBMbmC3PcAuQQ+bZXhDjLJiR3HoOWiU7Ha+Z7ZB7xbWztLpl9H5Z63gn9frQXCosyEqyI68SssA/eVGVID3LJjn6p21viMLOg0YleVVlWTxD4ukepA0fpfNN4jHsT+qN55Ic5YhnbTk51Os3axCrRXkd+H6bYCYuERhkvObvWNRUenw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtAMGvY20bmgMGGftxjxoJjsOJf8sgk/YYzKvoTyKxw=;
 b=hELW04QdSLGLvvg3t9aMy5GBSkc/xDM05ExwLWOIvNsoWaUX5MkV8WeMdT4LfvfuymKMeNFnzrhJkAdJ/RQhAIpoor0rSMawdItB2YH/hL2KBBHtO5/aWQRdNcF/m18Tn0jbVpKpAFiOK5ig7/RFanQ3m8L7Ov+c8KOWqK5bt5IXva4FTosBL61ZqrBnXJD1yWc52B/V3/GMLdYiVOefpujxP+upYgeihcuwkAPtAcXG0HcFnsNl8TW/ZNJFCFJLuduZLs0gFN0N5tCwhISTMd8XZl3DZM0POw7GsTIXFgdgjv69NHs1eqpVYtAV1wHMPCZiEzgYY9dSmSk/Q7XfTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from DM8PR02MB8005.namprd02.prod.outlook.com (2603:10b6:8:16::16) by
 MN2PR02MB5886.namprd02.prod.outlook.com (2603:10b6:208:110::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.16; Wed, 16 Mar
 2022 23:29:43 +0000
Received: from DM8PR02MB8005.namprd02.prod.outlook.com
 ([fe80::51bf:8780:a83b:85df]) by DM8PR02MB8005.namprd02.prod.outlook.com
 ([fe80::51bf:8780:a83b:85df%4]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 23:29:43 +0000
From:   Thanos Makatos <thanos.makatos@nutanix.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Joao Martins <joao.m.martins@oracle.com>,
        John Levon <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>
Subject: iommufd dirty page logging overview
Thread-Topic: iommufd dirty page logging overview
Thread-Index: Adg5jKKwvNkxolKnRPWJ5nYfZVngmw==
Date:   Wed, 16 Mar 2022 23:29:42 +0000
Message-ID: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d96fe7c-0149-4176-0b47-08da07a4d974
x-ms-traffictypediagnostic: MN2PR02MB5886:EE_
x-microsoft-antispam-prvs: <MN2PR02MB5886D3550ED7A38B06A1E02D8B119@MN2PR02MB5886.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n1gwka0tPX4LGGLGx36+lHJXXL8ftIpxan7lYrSmruY2BAz7u165b1S9es1WbJZSsOTAxoROTnKOVQKhnP6W5IxtJOAJVv7cVyjQ1fts1mn053iFAlbX0FJiBUsFtf3dz86u2gE0uwTlFeCR3KxvSlgGc2is3ikuZnvt0q+EyCNZsmOWkBgW1chr/UaYMpSYlqGnnG67LYnYn93XH94z4kdo6oXo8HIyOMvrtuYOWEcTt59+Qv29b5204O+GzzPAx1OYM90UJV9yDOrVF0qt7xXDpIZnujAA2mgPAIzU99Ze0oIlVHRdzEp7JO2osAPSPoQbPD9dNafGj5+nnwrdgcY8IXvdTNDbf2FxpMbdBLlizH/rKFHMILgz6n1RCvq0qkFHeCusHcBNs+nke0jRANmvLHHMvNaWGNxo6GgR/di5ckfrxrr6P1TfPNiJv+m9V4AThGfTuK9lisBVnpjzLT+x2I2xN49xLZZ9Jvchuz9HSsAZo8Ycsn6Bmu1syYhLLNhKe0M/FO/OFaHaYhD8tkdv/0WHx398EqjGsbn8XKJWlVHvTlxOvkO90Fq6BxjqB4N1wEjGOraj4rZVPp4+HhGSFDdQuJpD8cB2tomuAlNUchXfZhboHCzA+m538EMIcwNN8ATUBcVol19MtVvXdh9mqDjR4aLkkXghdHKHghgUD+utKJUKBqr7vIZzpaCla00I8NTUvtwdpnY/ui9qV4vQJzhJj0FWhaO/vUKGuGC+jGiE0eg7+/iDP0Wnd7boNRd8c4/3aZjQxtpUBBLcsZcp7K8OWE1LBgMq/SvHpVTtlD3M9OnyN1Kcxw9W5LuKbdaPDAIx5jQR6Wtl5UvuiBc1mKiAFk7b/hhBWKRZUwg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR02MB8005.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(52536014)(5660300002)(8936002)(83380400001)(4326008)(8676002)(71200400001)(64756008)(86362001)(966005)(66446008)(66556008)(66476007)(66946007)(76116006)(508600001)(9686003)(6506007)(7696005)(55236004)(186003)(26005)(38070700005)(122000001)(44832011)(7416002)(38100700002)(2906002)(55016003)(6916009)(316002)(54906003)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1Kn5GIPt10YpR9WYewNenWSxm2XoF4f/sHM+LFIKzhxXw8C1s//I+VAM2fRD?=
 =?us-ascii?Q?0NW1XHaLHt1Hx7nKZJfSaVfFIbFq3OJNA5i1he6LlPahABj48us9Fg6i+fhi?=
 =?us-ascii?Q?Af+iGQDCEsiP3xqorsVh86BssVg7uvXd6OpPVM5mybUrLCzWVScRqOQRTPli?=
 =?us-ascii?Q?QHMR6rdKPYcujWD4UGbHp3muyp/NiipwXF216vHslJ6P7pQRDGS3pslJmnGt?=
 =?us-ascii?Q?zj1pvizZhd0iqTTvbQrFXIxDFqe9qYgoBh56Ab8kwn2wyrG2AZLuutA8L5hN?=
 =?us-ascii?Q?0SbxHs1ahAIYVScfd5olAZ8VyITTa4B6UaTMvqtHS80My+4OuzEEqkxT6XDx?=
 =?us-ascii?Q?h7XsylsnJKj4gZyuPVH2dODsfUScsVOGjCV8AXTUosbP+1LkZ9YoqMAxKlkB?=
 =?us-ascii?Q?4Vhx3jVjorE27MBZL2d1g/IzEEI1bA2qnPMjm4xgBH0gEcdb64DDFygRiIbI?=
 =?us-ascii?Q?gwadN4xdQSVx8ltSe63KlgZYedOFiOtbs5Du8QDnb86/WNPXTpONzMJjt0hL?=
 =?us-ascii?Q?Lq40CMBkHp8Zg4sC8GVwIXSqIC1uogCLRsrO8CneGfWEEYlYu/JtxcHsmf/F?=
 =?us-ascii?Q?Qt8kcTHhhb+ueL2PdkImz9iym1wWLsK0kxLLRYL7Bdmg7thjc1g23/eyjWdP?=
 =?us-ascii?Q?ebhNSpNJqdpPUZ0/3PcLV9KP2SZxCIWsi6lbONtUMXCTZ8L2prO40MG1eAhG?=
 =?us-ascii?Q?1IElplZ8bVjpbg/eYbIIdMPY05RkIHB54FVdiOgQQswTF6kC368qCPkfyUJo?=
 =?us-ascii?Q?HmnZuzPgxBttmQpBynUPIHK9EHTPTkTXHY2wOPu/d1oxtomPI2ijfN+qcxEg?=
 =?us-ascii?Q?lROvf4Twp3WBU1MeCz56akPYN9ySQALWFMZKAcGuLQsIbE6f8kGquJwj19er?=
 =?us-ascii?Q?OaL0iHoTE0iJk8lBmqahpWaRckLaQPA2yG49UWxd9q01EFW+0gGUWDwiy+Lu?=
 =?us-ascii?Q?c2TeYtiAcrzYa5Sg23udN6+2biJVZWYMZjkF6aOackpgyNltmL+yLhsJQ6Xs?=
 =?us-ascii?Q?HAIE8DqLLclvh+v1gHPbL3cf+SjgjZ+drqXqAyd9XMFMA4Sv07pNdoLCUdDH?=
 =?us-ascii?Q?tEl5DONxB4fVc9jnDl0aR1TG1jQU8cuPoE8/9QQkbALaRVyPwjbQhFxuDB9x?=
 =?us-ascii?Q?p5Ver/MxWPB08SBySfY79SNZ5MNhGRs27b5Vg+ftrMeRmmLueER0uNgK7QJp?=
 =?us-ascii?Q?Fcde0+OYbWYIdwBoUgbJz++3O88e1Nje35AqGyR0QmbyOF5Olb0/fsK1wYOj?=
 =?us-ascii?Q?k8dcnjNjSgo7WHZnTmICIt/1QNQI/2H9zcJqWoNS6mGq2S9oCivgQ9uQ7I/l?=
 =?us-ascii?Q?wYrgpWCEPIeELEQX6YQ8mjr7+CJCbs5A85igc3u5EfHEW0CJCtCggLncXomV?=
 =?us-ascii?Q?YCKSajedSye/V3S5yP8J+cgiMyS52XsM7KdhA5fR7njs7aFQzuLz+iUoLzIB?=
 =?us-ascii?Q?Db6daUgq3mK6m3aT+RSw6wXCkpdqsi6u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR02MB8005.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d96fe7c-0149-4176-0b47-08da07a4d974
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 23:29:43.0169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hzHl2xFquGe2ihr+ZjPnzJv35J2bjZn51cnud6RdwECZMzI1OVlClj3lvKoQUSbL1JtmCa6ewv4GjKN2r2SR+6jfu3Q0oDCVuPg5g3vY2K0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB5886
X-Proofpoint-ORIG-GUID: S7tUAhm67bu-wC5ulcu0J-sNZUKns7Vw
X-Proofpoint-GUID: S7tUAhm67bu-wC5ulcu0J-sNZUKns7Vw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_09,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We're interested in adopting the new migration v2 interface and the new dir=
ty page logging for /dev/iommufd in an out-of-process device emulation prot=
ocol [1]. Although it's purely userspace, we do want to stay close to the n=
ew API(s) being proposed for many reasons, mainly to re-use the QEMU implem=
entation. The migration-related changes are relatively straightforward, I'm=
 more interested in the dirty page logging. I've started reading the releva=
nt email threads and my impression so far is that the details are still bei=
ng decided? I don't see any commits related to dirty page logging in Yi's r=
epo (https://github.com/luxis1999/iommufd) (at least not in the commit mess=
ages). I see that Joao has done some work using the existing dirty bitmaps =
(https://github.com/jpemartins/linux/commits/iommufd). Is there a rough ide=
a of how the new dirty page logging will look like? Is this already explain=
ed in the email threads an I missed it?

[1] https://lore.kernel.org/all/a9b696ca38ee2329e371c28bcaa2921cac2a48a2.16=
41584316.git.john.g.johnson@oracle.com/
