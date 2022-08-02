Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E94A587C6E
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 14:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbiHBM2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 08:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236872AbiHBM2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 08:28:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7345018A
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 05:28:36 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272CMJHn005064
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 12:28:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : subject : cc : message-id : date; s=pp1;
 bh=YLHuI01G6tuX0Iz2lttcO+24I3RoMS8aWRiPANIxGL0=;
 b=kgjfn8qyr0X/GzczWb3dmoKKz0Esidsnwo7oRzMzQdFhpwHTm7jRGkAWKehZDEZ8rt2v
 KyrH/TQNTxZVjK2PqwnmglFTAj3EfCMI+2NW6WsPb8hug/kPFRqI/XaFuj/jHxvZGg7t
 2hz3SmwwtiMJXxjElpxvjYMLHgOhkl3jdao/anOEad+Hdehf4UDlBQ82z4Bn9mXxGtA1
 qDAY1ywQZVB2AFKwsU9zEbHeZKXduxoa+hw1e+5KSmF0Un2SM3zb3HNs35SJE7SNgeSm
 5DUe+T770SCQhcYII/C+2qy0uBlfgLDYL6OXl0WNV6Vqss9j1RpkFOQt1TMs3qAmel6W vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hq3v6r3vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 12:28:35 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 272CQVo0020526
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 12:28:35 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hq3v6r3uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 12:28:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 272CLuZK007904;
        Tue, 2 Aug 2022 12:28:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hmuwhuq0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 12:28:33 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 272CSUfk18088430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 12:28:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07CEA52050;
        Tue,  2 Aug 2022 12:28:30 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.93.29])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E0FF85204E;
        Tue,  2 Aug 2022 12:28:29 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220728174735.49f5322c@p-imbrenda>
References: <20220725155420.2009109-1-nrb@linux.ibm.com> <20220725155420.2009109-3-nrb@linux.ibm.com> <20220728174735.49f5322c@p-imbrenda>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/3] s390x: smp: use an array for sigp calls
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Message-ID: <165944330973.9876.8801911829146776321@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 02 Aug 2022 14:28:29 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C3iTWRlgXUtHf-QniElCnTiJDKQWJ3py
X-Proofpoint-GUID: T_KnPlopJ87uklUdfM7hEd0YcXyZ7aC3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=835 malwarescore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208020053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-07-28 17:47:35)
[...]
> > diff --git a/s390x/smp.c b/s390x/smp.c
> > index 34ae91c3fe12..12c40cadaed2 100644
> > --- a/s390x/smp.c
> > +++ b/s390x/smp.c
> > @@ -43,6 +43,20 @@ static const struct sigp_invalid_cases cases_valid_c=
pu_addr[] =3D {
> > =20
> >  static uint32_t cpu1_prefix;
> > =20
> > +struct sigp_call_cases {
> > +     char name[20];
> > +     int call;
> > +     uint16_t ext_int_expected_type;
> > +     uint32_t cr0_bit;
>=20
> does it need to be 32 bits? the range of valid values is 0 ~ 63
> bonus, if you use an uint8_t, the whole struct will shrink by 8 bytes

uint32_t is clearly inappropriate here. Since I see little reason to optimi=
ze for size here, I would argue for int, but I am also ok with uint8_t.
