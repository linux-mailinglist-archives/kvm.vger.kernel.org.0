Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A6D77FB57
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 17:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353400AbjHQP6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353395AbjHQP5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 11:57:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CE530EE;
        Thu, 17 Aug 2023 08:57:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HFm2n5014755;
        Thu, 17 Aug 2023 15:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=1xMUcBWOAKg08c6PknqlCp+rA7+Uxm7x4F1GS4EgGnE=;
 b=ItDR+GHg8OgHc+2eTYhqbSjBag3T+YttRbi88Zf6/ePJwAp0mK9di2duydnoQ99Orqhn
 CL0asTKnoVjpkXkiEb8wRZQsyPJfdnu3Gaa3nw9WFgUmmCHxlMUcEzyTPcDombdziv2m
 EJLYUhehSTFHjBSrlHBfZXRd0iP4Wf0mpnqYuhi0bfOeqI5TKstq4Ff6ApnS1c2zPVBR
 qKnru+3JeEcjDrLD4v2dUwvj/0X7Ih/n7apns4dO2gsE9rfuTcZClEJuXz9HWki2Axpi
 fx0KqK6v/p5mnIAv5JVStVSsMdYfMA4wecmR+1JJfByChoPT2cX3cpGjUveponS3rw2M ig== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se2xwsxyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 15:57:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37HEREJt039513;
        Thu, 17 Aug 2023 15:57:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sey730fhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 15:57:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vm3DnUiCsVO1P3HarRWaYCBHo0sHHrjp1t9j6+6CWgltof15hyodO6DD60ktNWRgC225c5NuPmw3CmoEdCZTWqfM+EQdnZwxNDf8dLrlsXxZOd0QPIpMd6PhCVT8/HR6ssiDLfc98l3/SemKGiqiq4pUSHr6RXXgCVpMOuW8xYQqxmj7WsdxU0B78u9vBFAh3Svx5l09v/WmwJ8Cn3y3pwc17RcFXmqHtK5HiAufy0zR36rJFzLCR2OcGs9XnWryLZWivdkWUgg2t2ZlMxo7DyeqwOnDrf/AGaKc5wRgYeZzHsuIVSi48uAvSzVU4ZKQTUGOI1SkCsnd6nAGfzMuLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xMUcBWOAKg08c6PknqlCp+rA7+Uxm7x4F1GS4EgGnE=;
 b=msIFvFe6BU/AsBgWUrqRH9eSbw2/6ZAsjQZwbLfRU/BtoQPqcRZK3hzE5BuoEEBYUbsDx9WgB/K7LIFM+50wP1Fwo5MAY2cy7hAnSoTbqVjk2X5FHSSQEdCCp1qzU6L6f++1/Th80wVRZo/8+c5aycN24iIRf6kPcLl7QinMB1Bxs7S+JvwH7KZtFUjkqZZ6HCvtFNqIQx9LraCxUumyBzxxTinyo6Jn0soJDixpCVL6NxiZF/gU7WY00H3NyTIiwVpF+K/4XPEuN7x8OGBmNsWwT3dQj9j1V4gKevMlwy15CtwTJvi3bU3Mmxgg6VD59bsey0Vx0cDiuet1glGfgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xMUcBWOAKg08c6PknqlCp+rA7+Uxm7x4F1GS4EgGnE=;
 b=vj3nQwpCkif7icIvI+/n3bMWMHAvwZXmvTZV5UHwUjxu739hwL6Cf3FpCVBqU+JIRmfDuB/uysEstg/mC6SGN9aHmR87fS4amTE+Em5lIpxzP04A2b0IJuuyFewgeBq1KoXVdCy2ij9M9nHypq+UPihjz5gsx4MnDlP9D+V4NyA=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB6709.namprd10.prod.outlook.com (2603:10b6:208:41a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 15:57:39 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e%6]) with mapi id 15.20.6678.031; Thu, 17 Aug 2023
 15:57:39 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Commit 'sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then
 sendpage' broke O_DIRECT over NFS
Thread-Topic: Commit 'sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then
 sendpage' broke O_DIRECT over NFS
Thread-Index: AQHZ0SMM7jGcAll+1kuqtwDJI+Lc8q/upMaA
Date:   Thu, 17 Aug 2023 15:57:39 +0000
Message-ID: <4DB1C27A-1B89-468A-9103-80DEDBF1A091@oracle.com>
References: <2d47431decaaf4bba0023c91ef0d7fd51b84333b.camel@redhat.com>
In-Reply-To: <2d47431decaaf4bba0023c91ef0d7fd51b84333b.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA1PR10MB6709:EE_
x-ms-office365-filtering-correlation-id: 44dd13e9-4951-484b-033b-08db9f3aaeee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K4T/d75gsiQtbrUrffP4DnT8anAV6PwQWhOtIBCfr4PoZCwc5u1+D8ykW6+vMGiWUntk1g3qBeHOwMey68Yu2aa6DRqqVgHjMXQT6FgNxuf7gC9i7chjkWRPoltkkxGxY7/6JStr1EmI0FByPwfew52adqWG1kYsVgwIOmcut7C/DF94PrFgV4WnrelGFz1gQsc+8to6hgBPukTxqAJ7tk9ChLDZAXchQELfDkdMc9PzvjLAfWZ7cVwnIy6HgYkNmip0RzGLvxvGTi35l+u1IavzaS49Vm1b6Q7HGtNPIITw7frncROJkFuVz2VnU1F3g7w73K8boV/Fbyx2ip4N6n7KhT0jTRVOfbpeaPU8du44KKb1+f9D6VfsKEaYlWbXD6hrYc6JAKSTJVlPMsyhO6oZ7zsyu7wtBpXINQOuZIaSIbikUhrz7/lJJLH45CPGZuTi0LsRXK+NXW/5AbzDShCzZV3CybkVrm0f710JHQI0Gok0Bpgv7avHenrvnyT5DSrSf2ZKdTiGOvNGZ4HXktx9RDARn1+FIsGIm2ZmRIVczQbdKmkeENaFCw7F6dwRgYxhT12uUExC0+fQa069+UGTdMiMoG9/T36Z3jhYjDl2q95e5NTdH+kd2cLqvkvsuI2BgDXo4HOMqil0su2VEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(346002)(39860400002)(396003)(451199024)(186009)(1800799009)(36756003)(33656002)(86362001)(5660300002)(83380400001)(8936002)(8676002)(4326008)(53546011)(2906002)(41300700001)(26005)(6486002)(71200400001)(6506007)(2616005)(6512007)(122000001)(76116006)(478600001)(966005)(91956017)(64756008)(54906003)(66946007)(6916009)(316002)(66446008)(66556008)(38100700002)(66476007)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RlnlvPDccIn6UdMt0VmpytusnqD9bfDAm8a/vdnK8WkFdLSrHhoRoDGceuty?=
 =?us-ascii?Q?2MNspfd4/BpFL+A/B2TaiiBIjTYCarY2ddSEzFmUbOSRQxsVIIn53mdZf9Bw?=
 =?us-ascii?Q?PM35yQmN0mOJVN9riM5LLbJe2OSVUWYAQSUlxA6zFwtk/zX2iq+QcQUtro1c?=
 =?us-ascii?Q?rti4oF0JDedwCzxln5px+zHfgeoTVQqCXsT7r3vACuEX+cVXxiizLCWrYHOE?=
 =?us-ascii?Q?MxuRsMDZ4atDpvsIbGROyaCQtdmDxybv0+Dqpf2ROvBOd7nCUqZ/P4Ch/0GU?=
 =?us-ascii?Q?zoL/yj+ArOvJ4JhvTk3JD1cMqXe671RFCLc8KwtgOIKHYyqGWpqLbyzw5/FC?=
 =?us-ascii?Q?CShRXjq0OqPp5w6wT4YLny8geoxJcpqkYyvyf5QIwAsqWfXLKmxzWaIXiOIC?=
 =?us-ascii?Q?PUVSNPCs4ku6c9TGcXvjbUSX3QNmrxeIwr1ktYW8miDczNLbtdk87voDPKxl?=
 =?us-ascii?Q?+jJMRi/o02KqIqsAfevfXqHFFrnX3O4BS63cqKW8Iw1mXTtOHriwDyVSxYpU?=
 =?us-ascii?Q?g+bH8BwP0z+iod3im6gfJrG+0buHiRpST2mM2mm68B05FwMAWxtOIfQaQnHM?=
 =?us-ascii?Q?YS/hfvxtaK/thjvhtj/4ecdZdebOuiy4r1VRt9SNcxQuPZm9yH/PpvErZlZu?=
 =?us-ascii?Q?VA5PQP7f3JVNTzz7+Tp0O/vvuQC4BAm+uoBtZ5CgaFOrna4q+AUALLwct/gM?=
 =?us-ascii?Q?KajvA9yf8zcE363MbMv+Ct1Ts3ojxjVG5hjNMQfpQa5/vVRG6rT/xM7GVi51?=
 =?us-ascii?Q?PHqqG/Moo/WIRnEMAMLQpT8ay5bUaY1MRk34Sf+rHAGpBBS+EI8C5kbRzC8w?=
 =?us-ascii?Q?7p/Qmo94v0ZIk+woFF3LzUrHgWOizQUL1WZC9WzzQ88POn9o0O+Z3ALy5/3r?=
 =?us-ascii?Q?9gB5zfsAkmCtphIUcjKOPM76rp2JSSIU4r88ZO1j5LPFve4z7cBbIz2dvq+g?=
 =?us-ascii?Q?78Rjxf0zBAaSiIAGk4KxwTKiS0U5uZyGnttdNcNyqNZWYFxRpo0+lZD+7/oT?=
 =?us-ascii?Q?sx9aDO0KMxoqQxINzuSey80r9qO7sL1XKwEr+uwUQOj8pMbviFHo0zawNl4r?=
 =?us-ascii?Q?qkKO6Wej2eV1N22ZOUpqVcJccGIwirNZVQKV69VA6LNPHrMoTbTIyCPAHaQe?=
 =?us-ascii?Q?fl1WAUViMrcYgS4IkfmXAlx6FsLCTVo5E6bTOFMqWhT8urt09D+InU4Dq2zY?=
 =?us-ascii?Q?WuIKj+miarSgh5NlPtDVzkAIkI3O3WYCE1niDOCSJaZDDDdOq2EsRdTIMtop?=
 =?us-ascii?Q?3vofvByCQWw/2Md0iYi+JfNxHiqIK1iBHm6TPobTrGaYNsHTKjty6VedCPZM?=
 =?us-ascii?Q?FWtW3PIeFxEaFE3pTAtAEaCjN6gmqikP/9bYEsLzZoNhK0+7+3Ex3THwIlpH?=
 =?us-ascii?Q?3Ix2U3CsRpPjWaknfIqVZMhxcEgh4NcyyLyD6WThM15VV4ke9yXVtmuQk/E1?=
 =?us-ascii?Q?Lh4JPwkcs+Gjh5M4vNplBtuJsfyskN1An8ZHmSv3ceMlbAAxFiNJZeoWguwz?=
 =?us-ascii?Q?ej4M/a5qHOkeGc+v1FqwINokPLlontET53trOWaCkgtgpcWBFTPIP1mQJFUT?=
 =?us-ascii?Q?tppGwJmMuqBkD7d69FHrOK2EcyhCt/sKN5hAKLoiBbUMRXpbtVgjkgNK4bSl?=
 =?us-ascii?Q?ow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2F48CD7F2B4A942A70DE01CD6B18B12@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: h9JTeLlxRAuHFf1mLH5kUPjfv2Ze9j4hrPouJhCU2rXdSdAU4hk/ssywh3l141mWnOR4mJ2jKqX6B4mJqLZlRcnkrIlwHiF0VaxSVYOP9q7U1BTi2y4DoSx2iIFbuqC+aaadoIykwQPDCivOIQugpHqUyFt8zmELUTflHTRAC1uby3aER06sjQRBaqoQPEkIwNWu4f5gwdmYHVClQe/pdx3JGvl6jKSAyOsjDNDPDKxxksOND1GWHIrAdnIr4NDpIkh5aEDwVZTb/qJdd9t7C4RIckG6jlPR56YEYo+9d6uVFiMkY+yzeLlc3RI1ng0TMsD9RyloijJmxRT/h9x1yk4wQK1nP+tlOkrE9tV+sLCSAVbcrxurzqAN3eOOHQkYkxK7OAZYTfah2tsDOccXk4D95ouB0CzEdJGFeNMupMh1gaf+Y352cD1PdTSWkYQd2pi7j+ldwEiCKA9iFLwt/lauUN+gVnDaXZwqplGQFoL90AkjzLxpNqDkHU9J2nQqBQx8KUkXSBPyBCTHQ3xqLT67WUJp4YI42stb6iwWEIiyZpbdajXJoWZwzitMErF53mvU9jdSoDhY1ALDjTu0fKT7uvc52CCZZ3k8fMXpQaSKfWKzp0Ykz8QL9yfpCkIt2xgUPk0stOxNrLzAXWKvSqg/DAm/sgDakGr2CyyjuBVfhpilQwOAJ/NJ9T03fXhbeUlA6+0CU1oRXDdryMmpnPIKy3gAjgxjpRgR7yIw727c4TBk6XJYrGjR9YAQot9UVcCk88qTC2tJR9DQvo4O3R2ZIRqMUUxy6PZa5Nrvf24=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44dd13e9-4951-484b-033b-08db9f3aaeee
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2023 15:57:39.4199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wvo6g9NT3XfQgkBedlrIu7wT6VSPSETI1blYVPsKlhpavk86vxMeeFE8pHDSFTsmkWt2vN94ok9JcNNnN+6tSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_10,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308170142
X-Proofpoint-ORIG-GUID: 6tLWWNoiFz9oOiRaSMG7lloHolzOcSmW
X-Proofpoint-GUID: 6tLWWNoiFz9oOiRaSMG7lloHolzOcSmW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Aug 17, 2023, at 11:52 AM, Maxim Levitsky <mlevitsk@redhat.com> wrote:
>=20
> Hi!
>=20
> I just updated my developement systems to 6.5-rc6 (from 6.4) and now I ca=
n't start a VM=20
> with a disk which is mounted over the NFS.
>=20
> The VM has two qcow2 files, one depends on another and qemu opens both.
>=20
> This is the command line of qemu:
>=20
> -drive if=3Dnone,id=3Dos_image,file=3D./disk_s1.qcow2,aio=3Dnative,discar=
d=3Dunmap,cache=3Dnone
>=20
> The disk_s1.qcow2 depends on disk_s0.qcow2
>=20
> However this is what I get:
>=20
> qemu-system-x86_64: -drive if=3Dnone,id=3Dos_image,file=3D./disk_s1.qcow2=
,aio=3Dnative,discard=3Dunmap,cache=3Dnone: Could not open backing file: Co=
uld not open './QFI?': No such file or directory
>=20
> 'QFI?' is qcow2 file signature, which signals that there might be some na=
sty corruption happening.
>=20
> The program was supposed to read a field inside the disk_s1.qcow2 file wh=
ich should read 'disk_s0.qcow2'=20
> but instead it seems to read the first 4 bytes of the file.
>=20
>=20
> Bisect leads to the above commit. Reverting it was not possible due to ma=
ny changes.
>=20
> Both the client and the server were tested with the 6.5-rc6 kernel, but o=
nce rebooting the server into
> the 6.4, the bug disappeared, thus I did a bisect on the server.
>=20
> When I tested a version before the offending commit on the server, the 6.=
5-rc6 client was able to work with it,
> which increases the chances that the bug is in nfsd.
>=20
> Switching qemu to use write back paging also helps (aio=3Dthreads,discard=
=3Dunmap,cache=3Dwriteback)
> The client and the server (both 6.5-rc6) work with this configuration.
>=20
> Running the VM on the same machine (also 6.5-rc6) where the VM disk is lo=
cated (thus avoiding NFS) works as well.
>=20
> I tested several VMs that I have, all are affected in the same way.
>=20
> I run somewhat outdated qemu, but running the latest qemu doesn't make a =
difference.
>=20
> I use nfs4.
>=20
> I can test patches and provide more info if needed.

Linus just merged a possible fix for this issue. See:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ master


--
Chuck Lever


