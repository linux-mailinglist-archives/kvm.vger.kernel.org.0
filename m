Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3761F50B203
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 09:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445103AbiDVHxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 03:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345341AbiDVHxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 03:53:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2171FA4F;
        Fri, 22 Apr 2022 00:50:19 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M63htL021975;
        Fri, 22 Apr 2022 07:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=txtBH824a3s768FgaAIM8rFrTacKlbUmsfWAk+cWCn8=;
 b=lwwi0oVf/sjAqxDwHGv49QIi3qRw/y+tLglOx5SrWxEHcyHT4FhMkzlJ7GEhcZJTmUig
 bM7fEfgEBOwb+0tu851jIqGX1boo0WWYf65y7WeUqyyE63EugKYGyUs+cnCB9y+Hj/qm
 UvkjI74h0B5uCxgHF4L1Krp9K47Xiu/yeoU6el8ux1GJKVEDLSYlv5h9S4ZCJkQkYC1h
 s5Q8m3SAbdb9ILI5hRxA3lhhWl8My23GZdx5AXgehl5IIXkrvWc6ppHNxygbo7ZCfMx+
 0ab4dNuw8jowbJM7Z+cHMXhRGsA+rm7g97sArpXN4/LbecMC2wTPGteREE3J1YBIsfhY 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjyk5c7e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 07:50:18 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23M7h2Gw027825;
        Fri, 22 Apr 2022 07:50:18 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjyk5c7dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 07:50:18 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23M7nBMg006853;
        Fri, 22 Apr 2022 07:50:15 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8rygd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 07:50:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23M7oC1c48038308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 07:50:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51E6A52052;
        Fri, 22 Apr 2022 07:50:12 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.50.202])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 125735204E;
        Fri, 22 Apr 2022 07:50:12 +0000 (GMT)
Message-ID: <b7044e507dc7828f4c75d737b190a33800645666.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/4] lib: s390x: add support for SCLP
 console read
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
Date:   Fri, 22 Apr 2022 09:50:11 +0200
In-Reply-To: <d8e6d465-3a8a-db75-1244-ed574efd9f59@linux.ibm.com>
References: <20220420134557.1307305-1-nrb@linux.ibm.com>
         <20220420134557.1307305-2-nrb@linux.ibm.com>
         <d8e6d465-3a8a-db75-1244-ed574efd9f59@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: b4W-k5qhw243tniL1PiHaMr8hXm-He7I
X-Proofpoint-GUID: xPPSDLIDvEoPS2L7d_En6ArbNMqhDk8F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-21 at 16:29 +0200, Janosch Frank wrote:
> 
[...]
> > diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> > index fa36a6a42381..8c4bf68cbbab 100644
> > --- a/lib/s390x/sclp-console.c
> > +++ b/lib/s390x/sclp-console.c
[...]
> > +       read_buf_end = sccb->ebh.length -
> > event_buffer_ascii_recv_header_len;
> 
> Isn't this more like a length of the current read buffer contents?

Right, thanks, length is a much better name. 

[...]
> > diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> > index fead007a6037..e48a5a3df20b 100644
> > --- a/lib/s390x/sclp.h
> > +++ b/lib/s390x/sclp.h
> > @@ -313,6 +313,14 @@ typedef struct ReadEventData {
> >         uint32_t mask;
> >   } __attribute__((packed)) ReadEventData;
> >   
> > +#define SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS 0
> 
> Hrm, I'm not completely happy with the naming here since I confused
> it 
> to the ebh->type when looking up the constants. But now I understand
> why 
> you chose it.

Yeah, it sure is confusing.

Maybe it is better if we leave out the "type" entirely, but this might
make it harder to understand where it's coming from:
SCLP_ASCII_RECEIVE_DATA_STREAM_FOLLOWS

Another alternative I thought about is using enums, it won't fix the
naming, but at least it might be clearer to which type it belongs.

Let me know what you think.
