Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6748458EB19
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 13:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiHJLRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 07:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiHJLRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 07:17:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4B672EC6
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 04:17:20 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AAqCZZ018808
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 11:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=AkvDxgxI4gBQPkosNnZ2Ta/gYWJGBtUNtvgXKcXRydw=;
 b=hJajEgIBLhtZ7WMXObBcv+m7ZUzqJNh91zDdKRrta7fZbVbgFJ3NdiQHbn2yrDpPPlLZ
 UDjNUilERAtKJSPGdOArS8f9G1g8ZA1MgGE0bVY3b1ySNvsPmEMYffejo8k7qXIcGyFp
 WM9+8+u/ZqdPKrdCzPreUUJVQkZy8A1ZPfJhNQopwxtzpfwlRA/V/R7mcJEbkXY7Zr+C
 GX3NpwteyBMTLF92kw/dyon6H2CGduImpnICLPOBSxybzGJ99cneirxwQ33KjE9twnaQ
 mQ1X41KPiaq+/N/XWiOQiiOE3gZPQe48xYKSL0Afmune+1deAp7BC6rSEnGwEZYc3WLU aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv2jxx759-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 11:17:19 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27AAthdf006391
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 11:17:19 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv2jxx743-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 11:17:19 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27AB6b3f029167;
        Wed, 10 Aug 2022 11:17:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3huww0rrd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 11:17:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27ABHD0529294952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 11:17:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75667AE045;
        Wed, 10 Aug 2022 11:17:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E3DAAE055;
        Wed, 10 Aug 2022 11:17:13 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.57.169])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 11:17:13 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220810115808.62c51ef1@p-imbrenda>
References: <20220722060043.733796-1-nrb@linux.ibm.com> <20220722060043.733796-2-nrb@linux.ibm.com> <20220810115808.62c51ef1@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/4] runtime: add support for panic tests
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Message-ID: <166013023304.24812.5953325859568084136@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Wed, 10 Aug 2022 13:17:13 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fgJYuZrJa-ja2R9-dYXwkt2Pztrrq_Ek
X-Proofpoint-ORIG-GUID: a40Z_7tfEIh_bGC2x6aYAgEZolDymdM1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 suspectscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-08-10 11:58:08)
[...]
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 0dfaf017db0a..739490bc7da2 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -104,6 +104,14 @@ qmp ()
> >       echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | n=
cat -U $1
> >  }
> > =20
> > +qmp_events ()
> > +{
> > +     while ! test -S "$1"; do sleep 0.1; done
> > +     echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' \
>=20
> if you put the pipe at the end of the line, instead of the beginning,
> then you don't need the \ . I think it is easier to read without the \
> and it is also more robust (no need to worry about spaces)

Makes sense, changed.

> > +run_panic ()
> > +{
> > +     if ! command -v ncat >/dev/null 2>&1; then
> > +             echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
> > +             return 77
> > +     fi
> > +
> > +     if ! command -v jq >/dev/null 2>&1; then
> > +             echo "${FUNCNAME[0]} needs jq" >&2
> > +             return 77
> > +     fi
> > +
> > +     qmp=3D$(mktemp -u -t panic-qmp.XXXXXXXXXX)
> > +
> > +     trap 'kill 0; exit 2' INT TERM
> > +     trap 'rm -f ${qmp}' RETURN EXIT
> > +
> > +     # start VM stopped so we don't miss any events
> > +     eval "$@" -chardev socket,id=3Dmon1,path=3D${qmp},server=3Don,wai=
t=3Doff \
> > +             -mon chardev=3Dmon1,mode=3Dcontrol -S &
> > +
> > +     panic_event_count=3D$(qmp_events ${qmp} | jq -c 'select(.event =
=3D=3D "GUEST_PANICKED")' | wc -l)
> > +     if [ "$panic_event_count" -lt 1 ]; then
> > +             echo "FAIL: guest did not panic"
> > +             ret=3D3
> > +     else
> > +             # some QEMU versions report multiple panic events
> > +             echo "PASS: guest panicked"
> > +             ret=3D1
>=20
> so we never return 0? is that intentional?

Yes, as far as I understand things, this is correct:

run_panic's status code is (in the end) fed to run_qemu or run_qemu_status.=
 These two functions rewrite the QEMU status code to determine whether test=
s succeeded.

Before the rewrite, return 3 means unit test failed; return 1 means unit te=
st succeeded. So I *think* this is appropriate as-is.
