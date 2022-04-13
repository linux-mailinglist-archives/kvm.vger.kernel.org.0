Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48184FF9A1
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbiDMPD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 11:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbiDMPD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 11:03:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E165113E29;
        Wed, 13 Apr 2022 08:01:01 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DEhZlc038191;
        Wed, 13 Apr 2022 15:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=cogtTAbZWTf0bpTU8ZNZl3ye8szBWAB35pK9lz1RNbA=;
 b=RqaGAY7fLfEkhug/sRz9gB9NVXaxUtw3wwvuWFrXCsH49ViHE9tjqaa+ahBr4qU/Dhef
 npSCaqDSsiYlRXYkFIWHzd5Gi4bQZ9wN34n+NihETy5yZgyw3M8HAjSRfwYXldHyCNEm
 mNN+jN3MJGwUH+YpPqzAb/eLiRPW1k90/8F9yPhqBE7gLkF90mIywhjqPDARsuAAjAoB
 83YAbpWIr1aPhEZuoMPuTF9RuQHA9n5Gx5CGRgSviKbtTHCzhLVYU7h9OFH3goHmvnQ/
 fiouexojOUi2RDwIKoUAzia5C7vO6QMZ/CrdH8b5HkkJLC2pfxXq2E2Xw7vxALKZCasT 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fe0hb8dhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 15:01:00 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23DEvFW1007301;
        Wed, 13 Apr 2022 15:01:00 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fe0hb8dh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 15:01:00 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DEvp7K020635;
        Wed, 13 Apr 2022 15:00:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3fb1s8nnhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 15:00:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DEmNhb38797734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 14:48:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F89342047;
        Wed, 13 Apr 2022 15:00:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 215A142045;
        Wed, 13 Apr 2022 15:00:55 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.44.32])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 15:00:55 +0000 (GMT)
Message-ID: <0f21ad244492d1b26d2091fa7189b9967be31f22.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/4] lib: s390x: add support for SCLP
 console read
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
Date:   Wed, 13 Apr 2022 17:00:54 +0200
In-Reply-To: <19e481fb-9804-b42c-7554-8388889dbf73@linux.ibm.com>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
         <20220411100750.2868587-2-nrb@linux.ibm.com>
         <19e481fb-9804-b42c-7554-8388889dbf73@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6cy-__V12dwOi39rI78pladdFjYtRxlu
X-Proofpoint-ORIG-GUID: E7MbGXhRBRZejwSkcs6jf63n6UMa-WvC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 suspectscore=0 spamscore=0 phishscore=0 clxscore=1015 adultscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-12 at 17:32 +0200, Janosch Frank wrote:
> On 4/11/22 12:07, Nico Boehr wrote:
> > Add a basic implementation for reading from the SCLP ACII console.
> > The goal of
> > this is to support migration tests on s390x. To know when the
> > migration has been
> > finished, we need to listen for a newline on our console.
> > 
> > Hence, this implementation is focused on the SCLP ASCII console of
> > QEMU and
> > currently won't work under e.g. LPAR.
> 
> How much pain would it be to add the line mode read?

I am not terribly familiar with the line mode, but I can say it would
make the implementation of the ASCII console more complex. Right now we
can just assume there will just be events from the ASCII console when
we read event data.

Not impossible to do, but I thought we don't need it so I kept things
simple. Is there some benefit we would have from the line mode console?

[...]
> >   
> > +static void sclp_console_enable_read(void)
> > +{
> > +       sclp_write_event_mask(SCLP_EVENT_MASK_MSG_ASCII,
> > SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
> > +}
> > +
> > +static void sclp_console_disable_read(void)
> > +{
> > +       sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII |
> > SCLP_EVENT_MASK_MSG);
> > +}
> > +
> >   void sclp_console_setup(void)
> >   {
> > -       sclp_set_write_mask();
> > +       /* We send ASCII and line mode. */
> > +       sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII |
> > SCLP_EVENT_MASK_MSG);
> >   }
> >   
> >   void sclp_print(const char *str)
> > @@ -227,3 +240,59 @@ void sclp_print(const char *str)
> >         sclp_print_ascii(str);
> >         sclp_print_lm(str);
> >   }
> > +
> > +#define SCLP_EVENT_ASCII_DATA_STREAM_FOLLOWS 0
> 
> -> sclp.h

Yes, thanks.

> 
> > +
> > +static int console_refill_read_buffer(void)
> > +{
> > +       const int MAX_EVENT_BUFFER_LEN = SCCB_SIZE -
> > offsetof(ReadEventDataAsciiConsole, ebh);
> > +       ReadEventDataAsciiConsole *sccb = (void *)_sccb;
> > +       const int EVENT_BUFFER_ASCII_RECV_HEADER_LEN = sizeof(sccb-
> > >ebh) + sizeof(sccb->type);
> > +       int ret = -1;
> 
> Reverse Christmas tree

Hm, I think it's not possible for EVENT_BUFFER_ASCII_RECV_HEADER_LEN
because it needs sccb first. I would want to leave as-is except if you
have a better idea on how to do this?

> The const int variables are all caps because they are essentially
> constants?

Yes, that was my reasoning. But it is uncommon in kvm-unit-test to have
it uppercase, all const ints in the codebase are lowercase, so I will
lowercase it.

> > +
> > +       sclp_console_enable_read();
> > +
> > +       sclp_mark_busy();
> > +       memset(sccb, 0, 4096);
> 
> sizeof(*sccb)

If you are OK with it, I would prefer to use SCCB_SIZE, s.t. the entire
buffer is cleared.
